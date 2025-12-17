class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.13.4",
      revision: "89eb795293f353d575ab52eb9252f73e0269819c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca3463ae1440778670fa8f11b7d85fb36e22ad9d750998f8d269f64a51844fcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75d958d48a369f5411c9c8d699eea9092dd88082666abf89fa151ed84050957f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1ecc75524bb00c475f6ca0c6237d6c1ce4e7b17d15d5859509a13c3df7aa6e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c39c068f67fed14fdb463248b0aad58d82e10e74e22caa9c607465e0196990e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "401449124e90fc8a27e8c4ce40fed3ce2ab105fafdec209f4e1f47ae350f9c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "028b78bacd2c2ec26ff77af3dee412e32ce8c9f15962cd05c910ebbffc7fbe0e"
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

    pid = fork { exec bin/"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end