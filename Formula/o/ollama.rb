class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.11.10",
      revision: "5994e8e8fdaca3815d5a49f27d3fab33ac9ef51f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca6e4455be07560af06f4f3e9b8d76abaf66f227b948f129027be8746ed1972"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a91fd471cc5964fbaa0291b521d2ee419a68daf0876d208ce043eb87fb3d098c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18e4262cb4b7822ad2f44311878a894f1d1fa9531831c81fe94c165c62254e2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "781f4ac84676d07823f324c6258cb80b168bac5409ef1de33fb390f9bc2ff3eb"
    sha256 cellar: :any_skip_relocation, ventura:       "d8f4e1f0f3b3ae0ef1492951c25c5e392d6b44e4a6d48cca67519bbe20096b35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5047a4a6a24f7340d89bc196ee3d4767bc0d45daf5fa06520cf7ba6da9f9a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95e728248d6c32c78cfeda1c7d06048df900d134a0ee9c2fa1fd54d960024903"
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