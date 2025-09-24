class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.1",
      revision: "64883e3c4c0238dc70fddcc456af569d1489415d"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dc7b8952601243e7cabd58a3fa5328455f29c53c1a082c442067ae66f9c6565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea45c9c722b759bd2e3818e38c46ae897305fc60b0f8d67a38ebb360fd21666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b173cf3975b480a9c7d4e4679256f402272d3836ace4717bbe14a2c93c8dd592"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ff37bb82cab6ca7c1ad2758d55ac9c7a3f2130a593ad3d0c31b4148f6998d72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d971771e2daa48cf487b683e4f432c97a3bf3e69f554f075e9ba58be67d31a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3a996a8143989bc415fab6f62d44329b9d74ae30faa31de0259b2278cd1e0a4"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama-app"

  def install
    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.com/ollama/ollama/version.Version=#{version}
      -X=github.com/ollama/ollama/server.mode=release
    ]

    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec bin/"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end