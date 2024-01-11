class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.ai"
  url "https:github.comjmorgancaollama.git",
      tag:      "v0.1.19",
      revision: "34344d801ccb2ea1a9a25bbc69576fc9f82211ae"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d47c689019c8a833160b08047dad755aa90806096b4df13a1138e1c7e7bed41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fdc10cef31aeeb58a374363bbe5eb3e306f62d210ccae7d61db3165c7600c18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df292ff672246605a795dad473a16f66e5f42db2cd3e2135abaf76d1123974a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "69fef436c48d136e06e1cdd023b9a5c27e6dcf3fbcf5b8b7c4444db1ced4646a"
    sha256 cellar: :any_skip_relocation, ventura:        "35c86a102ccb116451bea79adc3ff5001b2f37c4cf81cf6ac24beb6501b982b2"
    sha256 cellar: :any_skip_relocation, monterey:       "aacb10281c2cbdd9d3a949d0c1a5be1b059016f800587c862907e7870cd90685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebfb33b2e9571df2b9b57e9d7bbc5b2930742254829c65ef5263ca0b0912a838"
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