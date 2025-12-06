class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.57.tgz"
  sha256 "aa22e8e00caf74442d69489b40cbdd74d5d51da6faa7b4f4c3a55a6c714cacca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4654d7fa7af78bd9d90d65e7b12ea3aad3534ac65335d349e2a3402dcf9035a8"
    sha256 cellar: :any,                 arm64_sequoia: "171b0038bef722d0a30abcfe1193dbccb3f338ef73e21c00ad8ca35e4d1a2783"
    sha256 cellar: :any,                 arm64_sonoma:  "171b0038bef722d0a30abcfe1193dbccb3f338ef73e21c00ad8ca35e4d1a2783"
    sha256 cellar: :any,                 sonoma:        "c3e71d8df583e6eba43a7b3a90e8cfc0b120996e7a5a7ce71e8439acd6916089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f5d7c81b448aa0d90d1bde1081a1e696c15afb4a24d9e77a73d4d042ce1434c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a36af0af8fe0eadbba5e908f14b98db1018793fcff1779cfddd32cab0c88bf6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 5
    sleep 15 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end