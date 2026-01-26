class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.15.1",
      revision: "465d124183e5a57cbd9a301b91c2bb633d353935"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e2cc46b5563959d274c35e439f0aba64036023170a5aabe892d076df638d0b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d1659bf21d2fa9795592f9d62be4cc2bb2b557514f2b736289eff76a175003"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2f67a2b27b611da42b76aa630a4c9c17d758d0ae04726284e4c8a937bfe25ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "31f2901519f23203d60ecfbd7586f1bd616ff6f38ab04ee98e28faa5b3137206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14375690eff2c3eab38fa81b1522f5019605fddbf0997934b6d898cc3781fbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a84a20303bae0a01b980e9e86d5c9149842f02dced71b26894f15d6130ffb535"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama-app"

  def install
    # Remove ui app directory
    rm_r("app")

    ENV["CGO_ENABLED"] = "1"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X github.com/ollama/ollama/version.Version=#{version}
      -X github.com/ollama/ollama/server.mode=release
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

    pid = spawn bin/"ollama", "serve"
    begin
      sleep 3
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end