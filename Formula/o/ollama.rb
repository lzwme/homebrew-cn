class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.2",
      revision: "2e742544bfc5242be4d76c6fee5082c7e41b3df2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffafbd79eb4f623d5fca227a97e12e6327d78ceedea0b9f58044d60101fb8679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c84bbf027d5cdb41b3c80b33f277f41661e4ac47cfe7aacf0dd1839e9240a16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb09ba0fe298a984c96ab701fd3a162f4910943c3d228b7667bc8ded2d439daa"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbc463ca1e962fcc749fde55d2ed7fbce9b4c6efa5c2d9dcde4499a744978e1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02ebead516739c962b99b5b3503aa4518eec9e73a63643f01ba69598af8e2d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9aec8995f04d95712ab2cb6469de23d6ba2f9bb843806a4224840b1eb73e11"
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