class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.1.tgz"
  sha256 "1ba4c204a9a78e327306a5db5e886e98425cd57bcc4ec2798ed0df8172ddd74e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0211d2d805acfbda2dd0bb80bdce1c39fae231454eec5a713885413cb5e2ed9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0211d2d805acfbda2dd0bb80bdce1c39fae231454eec5a713885413cb5e2ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0211d2d805acfbda2dd0bb80bdce1c39fae231454eec5a713885413cb5e2ed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddbd186a7d997079456a67f5a52d7275af30a130e04330374df76376fbcf92a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0648e89aad94adcaa9c8b7eaae3a89264974ea66dfd9cc63e06d688cbdae408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0648e89aad94adcaa9c8b7eaae3a89264974ea66dfd9cc63e06d688cbdae408"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    # Remove dev-mode-only bundler and CSS-toolchain prebuilts.
    rm_r(node_modules.glob("{@rollup/rollup,@rolldown/binding,@tailwindcss/oxide,lightningcss}-*"))

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