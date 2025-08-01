class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.10.1",
      revision: "ff89ba90bc97e9f58b8378a664b904bbc94e6f26"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49812fb1211cbf955d66f8244e423fb138fdc058498e2f2efb6cf6eb4750062c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60a8d280aa5c949a5f7c8d1b369e51ba111951353e1d836ae876e3efdca1d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60c25cc7c769ad158a0901f56c013037e0be5a4410540f223fd8d207c6c42371"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8a089fc99cbbe3e23f5af99cd5691f881aa9197326d524381a0e5fd23e31fa3"
    sha256 cellar: :any_skip_relocation, ventura:       "bb2ec02912d23fb8bec1923e90b5c823234d72c33eb1fd23de5e998e407380b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00c3c0be030cd609cb2057f287de477cce0ff2e4418d58c1f54423f3f3e7f7ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e6079cb3739308f21647bf67d58e6e634e4aac7d90aa8a2614ebc6d6cd78a1a"
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