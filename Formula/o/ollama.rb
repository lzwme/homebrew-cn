class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.9.4",
      revision: "44b17d2bfa0073e012679152421c0b69671d380e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2d83ab150576568a84d608b0d7a548f84036d648f412514c564f97080ca3d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b461cf0a3b2c2e54bb74038decd357bd54cfb25321000c430dab1ebd8c96c60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b4059a4873f62c324af88ef6151ca899c0b1e52283455b4b9ec6cfc402e61f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f20a4bf789020f01ae9ec56020e6f0f22dd9bc1a586de5230306d73eb5cd11c"
    sha256 cellar: :any_skip_relocation, ventura:       "4ac4c55826745b08d102839f1aa41ef559538a1487c3fcef9b1a48a353e2ba85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93f595d3fe3755f5a9f7f199c9d511029498d1f8def040f6210d85bbded7ea9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92ea08151c5b3c00f2b7fbc0910975d38c6828b0991ef2e0c41fd2e2425bd2b4"
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