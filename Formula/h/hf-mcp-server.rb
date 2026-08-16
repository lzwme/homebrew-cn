class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.9.tgz"
  sha256 "05b118f3651d70d8fd9403802e2d5f8555abcd7853b94899828737afca66fbcd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b14b4669699be3f4298ae3fc234464be024bd207fc3d002cbe471aba5c6f31e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b14b4669699be3f4298ae3fc234464be024bd207fc3d002cbe471aba5c6f31e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14b4669699be3f4298ae3fc234464be024bd207fc3d002cbe471aba5c6f31e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "561079424e5081196620ceed48be4c617d5b25e168a989888eb30aac436877fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2071db5afe33d50637b700dcea0d4e010060e5669e6b89de9dc21bbb26233f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2071db5afe33d50637b700dcea0d4e010060e5669e6b89de9dc21bbb26233f5e"
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