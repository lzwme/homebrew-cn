class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.25.tgz"
  sha256 "74af0169847616569ab32fd3e6274ae98388d8c7fcdb89abf87a6bc88263847f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1e6405a9368889bef9d1996bdaa9be8bd3e1e965a39e6f1d9ee894cab5cb474"
    sha256 cellar: :any,                 arm64_sequoia: "9bdb70c39d51e9305a2f1b4dd78805991554a4b709e2cebbed7f830a203afcfe"
    sha256 cellar: :any,                 arm64_sonoma:  "9bdb70c39d51e9305a2f1b4dd78805991554a4b709e2cebbed7f830a203afcfe"
    sha256 cellar: :any,                 sonoma:        "afb2c023cefa0de0656dd270976aac71f415e2b5f8780c302ca21d4e9f2484fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70888b24bcd9745b94c0d03bf066887c129feef969cef2dde9f988fa60d1f00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6feb4bd9ab22b6c96c523b642d8be39a9b7b4201a4dba6b63c48c8d572a0ac00"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end