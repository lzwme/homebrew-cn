class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.26.tgz"
  sha256 "a117998a96c4712cce07d4333e448160e2eb3356b39876c546093fcb99eb734c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27bdab6655cb3b0a8dfff2dcf28a3c10b36a14cfa17e3905518629142dc540bc"
    sha256 cellar: :any,                 arm64_sequoia: "cde2836524e2639e1d355dcebaaab3a92872840bae771c210106862b9b1e0418"
    sha256 cellar: :any,                 arm64_sonoma:  "cde2836524e2639e1d355dcebaaab3a92872840bae771c210106862b9b1e0418"
    sha256 cellar: :any,                 sonoma:        "7a161ce15e66656546bb6f1c4b3fa49baa3d38bb9248ad68331df685cb23e79e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37b1abaeb2e4f0412d2c000ba533000a5dd03f68c75d18b0516d90159662bd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "513a68dc189a5c5b3fe3d5324fc59ba42d40efc0f31105017c6e7cc28dd87b2a"
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