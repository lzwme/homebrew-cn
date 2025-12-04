class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.56.tgz"
  sha256 "fa2d4b106a2af3c1b8763d5dad1e89be53aa77b7f03788cdef95da139bd951ae"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6f0a5320451e4a0568e78333da63f079b764186f50c234ddd00ab7193c4e894"
    sha256 cellar: :any,                 arm64_sequoia: "83f45ccfa40c9a47a3b1c3be26434615c306d80a4a355a3c0a606c7ec6d84d89"
    sha256 cellar: :any,                 arm64_sonoma:  "83f45ccfa40c9a47a3b1c3be26434615c306d80a4a355a3c0a606c7ec6d84d89"
    sha256 cellar: :any,                 sonoma:        "deb14a52230415373e459a901f0e2bfecdc857bfd6623e94cce3035ee40d6e37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d3893b3a2de89ab3e015090fa69cf2a764b495b077fc29bce6b9248200800df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c580c204bb8825f50817bf96c60dc04488cdaa11d6c94d182540bba2faafcf01"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 5
    sleep 15 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end