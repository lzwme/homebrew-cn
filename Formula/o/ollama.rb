class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.9.2",
      revision: "ed567ef43b5822423bd165f5f57fb6bad5fce1b3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feb750f5756745ff0fda6985ec30dc2ed97d5a595bf5112d95d1ff51d6712802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0865068722f61daa9546750268b6725c91797004ca02a5346eca834ed1219f1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e306c6c8598997ab687e234556daf07a2822f1faa982c8dbc2e7161d7cdf1d80"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e9261865d611dd87304ccaafff2daf0009cbb3b0934cf65bb9a93f1d722bca4"
    sha256 cellar: :any_skip_relocation, ventura:       "45d89d9c0af14a93a2c750bd1e3a393f2aed5b4b6cb44aac35486a7034ac9d3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99138a22348e3c2b6156ade9bdecbb1dc1e21eeb2e1f19ed5b733cc28f5ba657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ebd6a49bba24e66f8619161aed4b557084599ba26304a2fab429f7927ac9fcf"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama"

  def install
    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.comollamaollamaversion.Version=#{version}
      -X=github.comollamaollamaserver.mode=release
    ]

    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var"logollama.log"
    error_log_path var"logollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
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