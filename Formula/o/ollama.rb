class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.11.8",
      revision: "4383a3ab7a075eff78b31f7dc84c747e2fcd22b8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8918d80418796643b1f8211503a43c495ac355cee456917f572840db9840eea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfe0d2307a007e7bb579b80487a45201b28b622ab8ffecb610055d06d2cfecb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be9cbc57fcb0574b694395ecec97aa92379dd0554737ac8220841a045ac0b4ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d7be899f1466d3936ca6cd7eaa9295a356b5b8a9e0851172f9fa3c4da57a38e"
    sha256 cellar: :any_skip_relocation, ventura:       "ca6cd088dcf58c032eb4ba6faa93a09cf095ce5e38c6a2d17e081662b258190a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f2a86b980ab1b1bc3be9d2cd7f70ee439ea136e4a663540abc2e783ee5ca310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3baa04f08bed42324ea76f513a3fb01036aeb91bb570221cf8b9ec728aa16dfa"
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