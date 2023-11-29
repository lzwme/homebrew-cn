class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.12",
      revision: "16a900630616f47ea18026150cad82d5e8008c01"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcae5937029d94add093af907d11455c5cef35e70dfc7a4ef1dba60f242e275e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46a393a9e39dc8f6376e0f5c85d98847d850b8fb4d56c16d640d63ae331a3696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cb4a86a48b15a08370004ac50db573474a14d86cde59f9924a907bcebdd1b6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b8837f6afd90cfec2ecba3443c5ca7281ca26dcc430d94e500866e800599156"
    sha256 cellar: :any_skip_relocation, ventura:        "f72bbc0b669071ebdd53c2739482f95e974ed63c6df24a6f838906552cf8583f"
    sha256 cellar: :any_skip_relocation, monterey:       "c4d4c711f37c0ff4d862724f3033db2c2e35f26cf519a9ae76b6e2793032e852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d8bee491d83ddf1d966b5f82a0f36c108edeee925a607ca1160bd75ebe35b1"
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