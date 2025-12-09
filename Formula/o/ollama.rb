class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.13.2",
      revision: "0c787231741eaa2e6d5b145e8565a62364a852b3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f3ce40690d055434c5d98d5648b29b1f6afa7b4fda05d6a0d743bb956ac18b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26231b8d5205af855fa4e9cd06b23fcd810e7564290fe347b26ea20a237723be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cd4dd56fbf1ccbb562c16489da53876c475147faa8c31da0066142d34de5344"
    sha256 cellar: :any_skip_relocation, sonoma:        "594e804e33cd7652964ec7ef5da784ce6b47f9742a225372f985d030cf24c998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a76130eb26699d3a0bc846d46b54f4233e205c4f99e6698619d4ffae5153fec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce5bbe4e771a4d1905f37c62724221519cff775e8721af9e27a2eaac98b4081a"
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