class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.23.tgz"
  sha256 "9103dd02d08d9a0009271304e4cc5c20270196ad257b6c64ab0245ec58ac564d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "143f5967ad0cb5b2cd170c132bedb9a29ea54e20d74d0a01346a905b11935a74"
    sha256 cellar: :any,                 arm64_sequoia: "11f083935f288540be242c3c2c87cb8579ec8fd829b0774ac7546e397b6067a5"
    sha256 cellar: :any,                 arm64_sonoma:  "11f083935f288540be242c3c2c87cb8579ec8fd829b0774ac7546e397b6067a5"
    sha256 cellar: :any,                 sonoma:        "6bfbbb7f0f5f51e8658f815e38b693a0dc0ba87fff501c2bc1d5743e49091de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe8004723c6477f00a83546e117d93ae9fa78a6b108250e99da2c64d15139c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6793ca2ec86e956127b93348f601219fbefea4cfd3c4c81f02e32f4cce4038d"
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