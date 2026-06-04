class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.17.tgz"
  sha256 "4adc40693f53674ca7e0f806a0e4f558bf63cfc5b7312eb7336464ad66ee3e7a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a1430c5ad68bafe5350046d6dda45030f5b56ccc54d5e4480cb6f5d54924d52"
    sha256 cellar: :any,                 arm64_sequoia: "913c7eb2bc1c80752fd2c965c74445a0a5d998e3bacd9ffdf3fb2a57689a075a"
    sha256 cellar: :any,                 arm64_sonoma:  "913c7eb2bc1c80752fd2c965c74445a0a5d998e3bacd9ffdf3fb2a57689a075a"
    sha256 cellar: :any,                 sonoma:        "ebc66db0b39f16bcf1a8291275fd797a69810f40ac48b5a83c63884056fff867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16e269cfd0fb72e6a01d65bedfeecd6743e02c1db482cf5d357235fd993fe9d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ded82ae2b2cec6e91bab1e6495340e05e79e1132507dcb432e5a9cdb9433e276"
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