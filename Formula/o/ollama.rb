class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.30.7",
      revision: "f0078ae4766d0d570e196158f20dde309bd96124"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99547afa6799bedad7f2607f19b32eff5d85c9620284bfc3219f10a627f549d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48dbd4cc197514600c67c53560261a2adae0b46b29dd731681eb6adcf89d2389"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda0b4d2366167f1ac106a9a013cb2161ac3fb1ac34d1679deca03f591dae79c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0527a39614bee568dd08ac51c7cb5e95d8a228c1d96cfccfc7ecb6d0dd60d9ee"
    sha256 cellar: :any,                 arm64_linux:   "4588379be978cc09c3cbb38791bb15cdc839a57368c072b5e4101a03ad96e084"
    sha256 cellar: :any,                 x86_64_linux:  "65439b0f0cc794103fa26575264b0f03cb2c3ddfa9e732a1e8bfee4e0fed8667"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage

      if build.stable?
        # Fixes x/imagegen/mlx wrapper generation with system-installed mlx-c headers.
        # upstream pr ref, https://github.com/ollama/ollama/pull/14201
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
    # Build into libexec so the mlx runner's required `<exe_dir>/lib/ollama/`
    # sibling can be populated without tripping the non-executables-in-bin audit.
    system "go", "build", *mlx_args, *std_go_args(ldflags:, output: libexec/"ollama")
    bin.install_symlink libexec/"ollama"

    # The mlx runner dlopens MLX libraries from `<exe_dir>/lib/ollama/mlx_*/`.
    # Using `opt` keeps the link stable across mlx-c version bumps.
    if OS.mac? && Hardware::CPU.arm?
      (libexec/"lib/ollama/mlx_metal_v3").mkpath
      ln_sf Formula["mlx-c"].opt_lib/"libmlxc.dylib", libexec/"lib/ollama/mlx_metal_v3/libmlxc.dylib"
    end
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

    # Test MLX (Apple silicon only)
    if OS.mac? && Hardware::CPU.arm?
      output = shell_output("DYLD_PRINT_LIBRARIES=1 #{bin}/ollama --help 2>&1")
      assert_match "libmlxc.dylib", output
      assert_match "libmlx.dylib", output
    end
  end
end