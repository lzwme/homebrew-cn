class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.9.tgz"
  sha256 "3604a4fac8b9dd61c15cd8390170d15bf20318b3528b056220ac77b5fbaa4bc9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c16b6e2cbe8d49901558ad416c5a6307d4029b0835bb5e6be8a390c56f89ee4d"
    sha256 cellar: :any,                 arm64_sequoia: "6ed348de30ecc4049baffc8ceefff4218fcfda0f4813809a3f2d874f66eedccb"
    sha256 cellar: :any,                 arm64_sonoma:  "6ed348de30ecc4049baffc8ceefff4218fcfda0f4813809a3f2d874f66eedccb"
    sha256 cellar: :any,                 sonoma:        "fb8f39117ab7750b0f22343f8091f7cf999f789b058c0c885ca783498e97c3f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93c59cba3a68afd0d3a5e5052fbecc9d87871993d7ff7d95e2caa87f5dfc637c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f232212a4bc4b0a7c9a71529d879860583cbbf54f7fb4379ad3ee22cc8bbaa05"
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