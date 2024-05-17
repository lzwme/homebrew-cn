class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.38",
      revision: "d1692fd3e0b4a80ff55ba052b430207134df4714"
  license "MIT"
  head "https:github.comollamaollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10424e1bf4b2c88520cec8d13a6599da9b15dd31d1c05eab739df552ba440c7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bf73cc3a93ff648091d9d5f8fe281db24c48d88c8d556714a30fa542488b217"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6651318503e8c2b9b50cb6f4fb3d7038ca81c963f870f06559edf1d382e170d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0989f874a013be9eab4548bb90204b91bd125816624ccbb25e82e7167f53586e"
    sha256 cellar: :any_skip_relocation, ventura:        "6f57ae883d76ff5a2fb25102aae148990d1cfa75673aa5927015ef27901a72ae"
    sha256 cellar: :any_skip_relocation, monterey:       "8cd6fb438d4a0fcdc150c6b87051d905190eda39bedf17407ebbd62962710ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb15e5ef271052625ba179127a7dc903dd0132172ae6a3ddd6ef20f4b2b982eb"
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
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end