class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.10",
      revision: "06d4fba851b91eb55da892d23834e8fe75096ca7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6a3dedc3c19984e66b560d9de9bd7630de2e2da24e31a6965d53b2d580b85fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2edd222bf46d24a4f6485bdea268291464e63a619b713543dcc4ee353eab4b23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caad0a763c2eca4de7b5a0855e7da2834b6926bdf6fbdd263eaa449eb1d30a0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb7971b3844cd2900afb1595dcd22ec8885390a7e3b9c5dd0de3fd5555074b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b0f3f4c202985ad64134b421eef10993e98e8000f615e3bf24db8dfa7d50404"
    sha256 cellar: :any_skip_relocation, ventura:        "9002c79ab13ca63a62fa257a243921cdfbf88d2c4a05d29c73647c854c561b7e"
    sha256 cellar: :any_skip_relocation, monterey:       "b389d2ea19cf1aa8279b8453b104a2e97b3fa10763d094dc3759c8b703d89570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e339c60e015d09dbeebe2e59596ef72548c971e7af9cf3a262bd53061a2403"
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

    pid = fork { exec bin"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end