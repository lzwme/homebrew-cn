class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.20.tgz"
  sha256 "ab1bc3f64c8f296d2721304ed605aa41e471846b1584c4a763a0d8462b22344f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7337a64b89366a1713cc4689c7d30ca26c76b88c49f6127fcc914207b587b53c"
    sha256 cellar: :any,                 arm64_sequoia: "6e8951d66a35abc67de331e57acbea6b5f117f6cf9852f7e0b217bf552867200"
    sha256 cellar: :any,                 arm64_sonoma:  "6e8951d66a35abc67de331e57acbea6b5f117f6cf9852f7e0b217bf552867200"
    sha256 cellar: :any,                 sonoma:        "7312f3bea007a83a0fb837f8f1571db04d5e830995ec77de80f82cd450d04a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6282ff8d2493f7e907d04551ff15960e0f3659185b1d438d83769e5f42d8d3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95cc842168d683f782ae4ba0b1c4627ea53411f72fa85718ec46007146c26f6f"
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