class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.15.tgz"
  sha256 "6cd2c774a811056e55a2ec8e175d2924c596221ec4e985a9370c3f568b616a07"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24a1db4bfa62545dbd9155eb63911d531e70c2c14e0a8d7d88925f335c6e55ee"
    sha256 cellar: :any,                 arm64_sequoia: "c7ca02a2d435648fb7534f8fc93d894afb0b48779d2c9047ad225c472e3ce704"
    sha256 cellar: :any,                 arm64_sonoma:  "c7ca02a2d435648fb7534f8fc93d894afb0b48779d2c9047ad225c472e3ce704"
    sha256 cellar: :any,                 sonoma:        "9e05113548127449113e7d83f918f2c4c699a293db43a9136122509871e11904"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b903f82ebca0ee1b5c05b6e78263d76d0a1090b29cf26c60bc506bc38018228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f8fb34b77d0cd08f180beb81714c671bf9b473eccc8b98a0ad34e098e74c0cb"
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