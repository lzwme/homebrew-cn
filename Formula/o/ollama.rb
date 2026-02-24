class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.17.0",
      revision: "06edabdde1174bd31c1d93f3d9e5efc2d9504806"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67c2de8e43c1c272118d08bb0be30abae0fd842ef81ce4ecb7736b29e5f66660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5337b75202f55ddd9b772a32ebd8dc6dcf9da51468869661a417570a601c4a66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc8708af1bd7b67e942e4aa08944f61f278c610fb704c5a0046eef898ee1a2b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a398347c7768d297142505b5d8ef64c0256ae18ab1971bd6ad6f88047b1ff057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba296c6b8b64c142fe5fc4fbe5a114857eb00aa18fd9bc571966669bff050ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58cc9cf00beaf6eff77d9b32dd07f6a5101eb4bcf6a6250b0af79d9ea6bf6d0a"
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