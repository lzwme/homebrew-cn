class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.11.4",
      revision: "f2e9c9aff5f59b21a5d9a9668408732b3de01e20"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a9b0c70d8be6296686842eab6f4021e67bd5bc76d6949c9c9a452da15fc0698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ff32c98cf91d7a73c2ce2fb9823eb268d5cdf61bbe9c6bec58cd4ccb172929c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82e4ebf9a66d47d05505c76ff49e474b624540b70e90c79a6230d62b7512da34"
    sha256 cellar: :any_skip_relocation, sonoma:        "81ad5b344eaaa7b0552d36bb032e4abb84441a2729e687f085cda83215a3a248"
    sha256 cellar: :any_skip_relocation, ventura:       "c069246fb513bdb3c6648b10cd17ed922bfb28d4c562407028884b1b1fb5761e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0edb2d3ac9d48ccee851ccf99af2b0c4b97c21e0df9fb6b7bd9182036b5a61c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5564d29a9e1e691e523564d86b25e370d94b3b14c0095b27d58cde7f627a374d"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama"

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