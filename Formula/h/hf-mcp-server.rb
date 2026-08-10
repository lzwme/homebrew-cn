class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.7.tgz"
  sha256 "bf421e0d24bdbf6d4fa78f816e8cd3f469fd77c460fe53e9a848f91130683eea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ad633d80443fd396fdf9905b05ec2a954f4e54da16d1ee66dc469642fb21340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba072ff9c403930dae5eaad286fc5f55629583398428ef66bd85177603ef419a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba072ff9c403930dae5eaad286fc5f55629583398428ef66bd85177603ef419a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8668f09712e94e84caca0c4852d2a36ca33e9b127d21e648065531724a0f210"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fe7c1a91a81762ecac570521325317335ce2c0ba2ba6108d81139efa035d664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fe7c1a91a81762ecac570521325317335ce2c0ba2ba6108d81139efa035d664"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    # Remove dev-mode-only bundler and CSS-toolchain prebuilts.
    prebuilts = %w[
      @rollup/rollup
      @rolldown/binding
      @tailwindcss/oxide
      lightningcss
      vite/node_modules/lightningcss
    ]
    rm_r(node_modules.glob("{#{prebuilts.join(",")}}-*"))

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 10
    sleep 15 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end