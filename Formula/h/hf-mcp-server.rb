class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.13.tgz"
  sha256 "1b7c89a26d12a3f94558246c1eb6b2f33a224eab4d5868360814a3fc4a3a9b06"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "185148d38ded3a1c0a9d74086a623ac4a09a27cf56c7d2d338b5c7eae6200d67"
    sha256 cellar: :any,                 arm64_sequoia: "45af660624ea61fee8bc18bb82f5884653b79ca155ee03bc295ce75c35b0cf5c"
    sha256 cellar: :any,                 arm64_sonoma:  "45af660624ea61fee8bc18bb82f5884653b79ca155ee03bc295ce75c35b0cf5c"
    sha256 cellar: :any,                 sonoma:        "fd0c88b321366fb45c14c1f848012a7f32060944fb4e27449254ef1803382ddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b3af7790f831a6bcba436386f846905700e0d13756486f7c05ab114bc907a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b83cdb2cd0893d4e24a87264c3b2a7e23b0157044bfca0b7e3fd62c0b16189"
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