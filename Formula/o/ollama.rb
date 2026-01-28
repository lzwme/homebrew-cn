class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.15.2",
      revision: "3ab842b0f5033b0074f999fa25ce97a1c0ec9b29"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4eeea72a1c4c581dd4d2dc991527efb0bea7def8fe1caed8c1b2b1aee3e1f7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45b860de918ec0d0d1f3db945b26ab9aab21122957c96df914d0be1b422f53f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21064b68891ba0e9be808bccd4b9da6fec2cda4ac28200cbdf6113511237af95"
    sha256 cellar: :any_skip_relocation, sonoma:        "099c78df582a2231972469ef0125e25cbb2c49813d78e38b38387cc2ef164900"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f5aa1055bc742b238338aa64393f555ff08b050ba8647d2276dd557aae9133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fcb4445e970003cc1a5da5d349459cb28c575b9497b1e31d764033483afaf3e"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage
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

    system "go", "generate", "./..."
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