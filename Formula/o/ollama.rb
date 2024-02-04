class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.ai"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.23",
      revision: "09a6f76f4c30fb8a9708680c519d08feeb504197"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6c12265a722b2ed2b2838bfc257942a4c68b49b4398f5cf503dcc368a7738b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aec7bccd9e39be3d99528e94fcc6445e96e75e6bbd5eb125b75c7391b8f312d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2d1325bd2fbbabf1fb9ddc67fb733ce60aaa203374e9845b9ef3893702b176f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7992ff532d7bb26921970f1fd82bc43eb3a4c6e00f44788e4e6ac4433bb6f7d"
    sha256 cellar: :any_skip_relocation, ventura:        "6ba0f1208d55b6f2820f1f1fa7100c3a518bd7718a309410603097cde15efb08"
    sha256 cellar: :any_skip_relocation, monterey:       "13c8a5711e684e157352dfc0d13e567f8aaba5760c6028505103d31679bcc096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a69c272a579eb4df8b8a36e95a9d67b48b532c9e25342cc62afed8907678146d"
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