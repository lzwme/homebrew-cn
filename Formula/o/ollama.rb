class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.7",
      revision: "c88647104d1621b5021d6e3ca18fb8a1f5cdd394"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41559881ff4475227e8cf919529c1a30adbd98a6c3409006de48ef7b312654d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ab5fb4dd8c355c68ad22ff9ab8946769934c9dfad7dbb50a42c6ca63c51e17b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb9606cb1907bd84cf7203ae796e4ac7c0b573dfb7911d36f9d767ac925a8986"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ecdd1e6bff4cc09e44243040ecdb2e8ebf866a4e1947fa37ee6cc446176c59e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee91b9214151e0c0e2d9bcb96398ec66ce7fe6a7a9ba39cbcddebf1c0eac8786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d951c953c42067426f096b97dc3fae51626e1d4464feef175f660b9c46a6acd3"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama-app"

  def install
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