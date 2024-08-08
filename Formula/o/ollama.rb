class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.4",
      revision: "de4fc297732cb60ff79a6c8010a7c79971c21b4a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06f96be26f82c327bbc62b493874a3a37c2b9faaad197215c858176896013ab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d57c580b88a9808ebbd173868aa2a968890b2a20e023f27395a0b49e1a02711c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "652440a2a23e02694823341e0d53d171b01d91be2c864dfbd82db5a8517c4c8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a654fd4fe3ad50a9b69ef6f7b561364544583c3ffb1521bdaf42a5ad99945978"
    sha256 cellar: :any_skip_relocation, ventura:        "164c2117a81abe1cd2774b3f51f96377db237d5357334022fc0816d4445a237e"
    sha256 cellar: :any_skip_relocation, monterey:       "7986d2001730057c2669f887b8e2287211d7dea4c95b001a177154fac403e76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41064c6ea60b2d724927bfa39de413ccbaa4cb10c8b657c620539e521ab362e7"
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