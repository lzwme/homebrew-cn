class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.29.tgz"
  sha256 "48b183a946e58c9ffbac73ee01465343b89802e5ad4c965139a84e8c04fd09ca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "565cb950f175b45bfc8bda0abd7c5e6f8f1cec9e13f2bba715cb8da9da091f40"
    sha256 cellar: :any,                 arm64_sequoia: "e76cf6e794e2b7bb4894dda60e2c42a70bd18dc5b528f92ee19d6adf3fbbc564"
    sha256 cellar: :any,                 arm64_sonoma:  "e76cf6e794e2b7bb4894dda60e2c42a70bd18dc5b528f92ee19d6adf3fbbc564"
    sha256 cellar: :any,                 sonoma:        "303cd162a5eaa22eb9fa5c2ed277d1457a3a23d1ec01d7dfc0f203b187998260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0dfb07c4ce547a20089854ad1b2ea78b06d4d7065c334c939f28387bec41ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee895ff212f6cbe94ffd43f4dd96b744b031094586d6fb15efc13450db150d7"
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