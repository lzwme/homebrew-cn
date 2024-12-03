class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.4.7",
      revision: "5f8051180e3b9aeafc153f6b5056e7358a939c88"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38eaebb5b674f27f9fba9727789b99045a8275104868a77a31c0735e75ad281a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f28a71acb5ecb5bab0550eb0b19ba2a9e5daa28a64781db9cf511d2d46c18d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85a677c571004fa8f92379419afd2963bc9e68bd8f04d309d2a190ce519d5a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "17fb68c8c5750ee82e294145c79de71915f6f1b121111bdcf5419dd3e3bf40c6"
    sha256 cellar: :any_skip_relocation, ventura:       "246ec7192ab0bf6c34f3b28312952d8c6675b6be66825e1beb1b520ceb016a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b870c08707412438c03e3bb2cab972e32e9eebe05ac42e1675a5dac29fdd476c"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

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