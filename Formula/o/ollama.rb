class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.15.1",
      revision: "465d124183e5a57cbd9a301b91c2bb633d353935"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60b65805b9db4b7a95ce127d839ada458c20e6f678d66e5b7ad0266c2b14563c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b47c31e394c20af47cda53e1e03df20fa315b91e714478775db924519d3c32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2baf66743a486bda085140b1a6fb57976dd5486738bb981c9f006f4d1dba60cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "74aedc0b16277909ca09375986a498000b1b2d4f6591328db641c4c5babcb736"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb27f916aeecfcc118e9e09130ce0a0052eca36e635eaa2bbd58b52f879c8761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07c0b1a6a6fea4654dc50228c865d19fb814761390ad125d230c4f81fab5b7c8"
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