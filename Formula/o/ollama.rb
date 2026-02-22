class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.16.3",
      revision: "9d02d1d767b075221031be19ad9695f1259b3519"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5543b0d80c12da847705c57345537f3208349ad7bd8872b5f21d11ae7b9bfcac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f53dda24472351551881c364b4390121d00710f5f58d4df3acfdbb3b40f918c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de9f7a7460da96b4d5e5fdc5df7e98e2405f744704f9304e0cfe0071db5d4e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d79b9f2166f54daa1c18b7535bd6daf095babe00ec29081cc66bca2eefdff5a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6c978dc1c11f2d352c0a620aa7e8d89617ca79e4232e4974e050ebd967b8e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e193a4a2d86614c2eb45a4793997143486a269bf86851c46883ac26c3cff4b9"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage

      # Fixes x/imagegen/mlx wrapper generation with system-installed mlx-c headers.
      # upstream pr ref, https://github.com/ollama/ollama/pull/14201
      if build.stable?
        patch do
          url "https://github.com/ollama/ollama/commit/c051122297824c223454b82f4af3afe94379e6dd.patch?full_index=1"
          sha256 "a22665cd1acec84f6bb53c84dd9a40f7001f2b1cbe2253aed3967b4401cde6a0"
        end
      end
    end
  end

  conflicts_with cask: "ollama-app"

  def install
    # Remove ui app directory
    rm_r("app")

    ENV["CGO_ENABLED"] = "1"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X github.com/ollama/ollama/version.Version=#{version}
      -X github.com/ollama/ollama/server.mode=release
    ]

    mlx_args = []

    # Flags for MLX (Apple silicon only)
    if OS.mac? && Hardware::CPU.arm?
      mlx_rpath = rpath(target: Formula["mlx-c"].opt_lib)
      ldflags << "-extldflags '-Wl,-rpath,#{mlx_rpath}'"
      mlx_args << "-tags=mlx"
    end

    system "go", "generate", *mlx_args, "./x/imagegen/mlx"

    if OS.mac? && Hardware::CPU.arm?
      # Temporary compatibility workaround for mlx-c 0.5.x.
      # Introduced by MLX runner generation in https://github.com/ollama/ollama/pull/14185
      # Upstream tracking issue https://github.com/ollama/ollama/issues/14298
      # Drop only this symbol until upstream syncs generated bindings.
      inreplace "x/mlxrunner/mlx/generated.h" do |s|
        s.gsub!("\nextern mlx_metal_device_info_t (*mlx_metal_device_info_)(void);\n", "\n")
        s.gsub!(
          <<~C,

            static inline mlx_metal_device_info_t mlx_metal_device_info(void) {
                return mlx_metal_device_info_();
            }
          C
          "\n",
        )
      end
      inreplace "x/mlxrunner/mlx/generated.c" do |s|
        s.gsub!("mlx_metal_device_info_t (*mlx_metal_device_info_)(void) = NULL;\n", "")
        s.gsub!("    CHECK_LOAD(handle, mlx_metal_device_info);\n", "")
      end
    end

    system "go", "build", *mlx_args, *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = spawn bin/"ollama", "serve"
    begin
      sleep 3
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end