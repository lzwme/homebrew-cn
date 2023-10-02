class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.0",
      revision: "5306b0269db6c6c4f716ff6c3c4514d5aba74c19"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b339a472504d8f48d6201f70aa6beba835f516cb0125ef7b854010748e44e9f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b558949f95f9f9f66c6445252cab95ad17dd6e10a47ebb0b2e3013130166acf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05eb4ac5d750f536341e417d2c88a31928a099184a8d9a9b2ce5095b0516e673"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bb4d92119704f36a7c325c53cb91fcf90265d5bc0a65b1fb64294c90196f33e"
    sha256 cellar: :any_skip_relocation, ventura:        "a8bf3eee85beaed336d7cedb2aa9f864358ea2ca6d3da828b216d51702551052"
    sha256 cellar: :any_skip_relocation, monterey:       "fc161f42b2991c2c70445bb49dd2f1ac14544daef8f4540fff740c8c2826ef44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a3be4bb275de00d4629e099a52730f1b6054383a709e5b8120fe784425b5ad"
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