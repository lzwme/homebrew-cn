class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.11.tgz"
  sha256 "8cf1d575d636afac1082c8e67900027473f515340aff1adc502986b6484db84e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40138a76564d5b46fb031cdc8626797f8de823718536940ef28bf7fcda3bbb91"
    sha256 cellar: :any,                 arm64_sequoia: "5e1c8753149cd73491d3830a66d45e06b1bb1b07eaa9f77fa65375e74e4df9ff"
    sha256 cellar: :any,                 arm64_sonoma:  "5e1c8753149cd73491d3830a66d45e06b1bb1b07eaa9f77fa65375e74e4df9ff"
    sha256 cellar: :any,                 sonoma:        "06d4fb301d1de500de35375a28257ec67018f3e742ba4ae91f10e620a5615a60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94066a8554b312a3235414bb1ed86368a2d0d80d988e81fd3f350cd68d1cb68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1046ba79174a25af6a9aac7469f2130fdd20e38239442e3b3757b84e12b2cffa"
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