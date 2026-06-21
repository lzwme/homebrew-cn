class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.21.tgz"
  sha256 "08b51bdd2104b031a321f0a735c2275a1fdd2649b904715007b7e33d41d620a6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e4b5cba7fc94fa2a3ad9872069003c6b3ea0b26a5b9bcd9fa12a164e007ed9f"
    sha256 cellar: :any,                 arm64_sequoia: "cfed0824266c86c1a281216e086eaf81b5e60b70d3baf007f1bb5f262593b77e"
    sha256 cellar: :any,                 arm64_sonoma:  "cfed0824266c86c1a281216e086eaf81b5e60b70d3baf007f1bb5f262593b77e"
    sha256 cellar: :any,                 sonoma:        "7f356240d839f7239777681b77f5e876305ece13be2b1a2631db2541ed495c7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eab7f0f068fcba7eb19258638faeb5d124efdda119881f6958a81eb60769abc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41369e7d9791fe826be7092dad09ab3ad79db6c2991fb229c3bd19de3a234cd0"
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