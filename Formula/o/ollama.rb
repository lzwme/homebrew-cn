class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.13.1",
      revision: "5317202c38437867bc6c9ed21ffc5c949ab6794c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d882c5cb3ba4c997e1ae2166a1938633a1cd582bb5532606c80f5d59fbac80b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61273d480af5245fab07d8b3ba5610d8c4933bf214aeee90c8325cad6f9cfde5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb0e29ab9e598c43524dcda0e7f2dc0ad88c35949e17bb641408a1b1cefffc1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "379429caa0f7d0d6fda3a0a3695601ad7ccf27600cb906a313432b62bada4d00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33a870cef1bf9c483bfd962fbaf20eb979317e850c3c51d0027668afb642347e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "995ff3a461029605bebeb2b2de386bc4f56bf55581fc8b765c3560057d792565"
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