class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.41",
      revision: "476fb8e89242720a7cdd57400ba928de4dde9cc1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35936223bee4490b1eb57f8d5df21ac25fc804534ad5880f460eb34b5d653ed1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd3ee08078c909e35c7f901a68152ae6dead32a5cc37fbc944d73589abda5807"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bb85c8d3727ac2bbd064ff0a2a3a8ba8a67b9b6bce2a6e96893d8d8fa065d8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d68d84875bafb4cc0ff8c536bb6665e2ed5c9455550437cc5064b92b52d2c4a"
    sha256 cellar: :any_skip_relocation, ventura:        "4f363598d87d12c378925ce908d8d2b02f4ae9a9ffc9198d9eea9dc64d207999"
    sha256 cellar: :any_skip_relocation, monterey:       "577df24ef8cc505419e05d1968b688f594c36884eb02c184db23a9924ba84d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f709d0809c6c2f7d9731bca03f8687b8a2d6085ffdc0d43c64d1c1e4f0385a99"
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