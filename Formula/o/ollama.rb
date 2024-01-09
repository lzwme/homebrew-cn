class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.ai"
  url "https:github.comjmorgancaollama.git",
      tag:      "v0.1.18",
      revision: "3a9f4471412cf132f0fa7b872cb4f616a1dd8b59"
  license "MIT"
  head "https:github.comjmorgancaollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1e23649b7d648c5f5c555b0b9c3feeffeacc3705c8735ce81ea34452d4d9d04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7fa9af7aeb66353ba4152b1300f951200c8f64073eaf314a9d1cdc279bfedd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9654554758581caad6b43468292979591e2f45ad93101d39207cd6a73fbc0ffe"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e3bb6cfb9d893360de0df90e3fa898d40fc9c7e17d0f27c0c449684f5f2895a"
    sha256 cellar: :any_skip_relocation, ventura:        "7b10d888d8710bc727b9975a0ea85a435a0fa64412486b26255ef8bd08ca0fa0"
    sha256 cellar: :any_skip_relocation, monterey:       "bbbc25461e045aade459efac79ffdbfeb1b7d8e4fec07afdc1bb9bca19083e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f870dc257a6f1d61a81f6f3366492a9d9b7abc9492ef1e7c30aea2b04c9b14d7"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    # Fix "ollama --version"
    inreplace "versionversion.go", var Version string = "[\d.]+", "var Version string = \"#{version}\""

    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var"logollama.log"
    error_log_path var"logollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end