class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.7",
      revision: "9ec16f0f037720bb36681cb7534c078c6285c976"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19e076e95e85b5db647e9d85e9bc0c1cb55d23be4960735e0c3c8c1ffce9d872"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1bbb8e94719e51bfc2ee3aa76fb328eb0691a73a8e211c791630b3f432aa2cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54586229db54c475bcc21fabc89e5e7675dc516f3e1e5a41009a6279d0c3763f"
    sha256 cellar: :any_skip_relocation, sonoma:         "659f687b20f0c47f2c150a4222e7d0ef382f2a29987fbf91e41b8a863e9984f1"
    sha256 cellar: :any_skip_relocation, ventura:        "4c06e18fd3e29a3f06fdd09aede7ef62a0f26146461935ccff64988ffb64b537"
    sha256 cellar: :any_skip_relocation, monterey:       "684464adc3a6339b827bc8e5638e5b63e961b6c22ece59e1dd1c9850c702042d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7389e506de16cb8336efe3661534c4ce7da0f7de27a3e36e015975c337d74ba1"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build on big sur by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :big_sur
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end