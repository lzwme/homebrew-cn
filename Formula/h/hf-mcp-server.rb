class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.13.tgz"
  sha256 "f5c01653dc364e88f0d4fc67b65c050c3852bc415cbaede7a71be53ce200f6e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f40f371d0b532583803590eaf88256f46f8571541e0ffed90c9799526e406dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f40f371d0b532583803590eaf88256f46f8571541e0ffed90c9799526e406dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f40f371d0b532583803590eaf88256f46f8571541e0ffed90c9799526e406dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0677e6f33e4c0fb28b38984ca95e6f26f25687ea7de8d05d0142b7b3b334d9fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "268d2fbae05b49ae1f5099b11b152efa23b4a50dc941764379a91126063e1c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "268d2fbae05b49ae1f5099b11b152efa23b4a50dc941764379a91126063e1c7a"
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