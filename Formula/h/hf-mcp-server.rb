class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.26.tgz"
  sha256 "3bd86952211ae005d40019617fe2abf20727cf47479879bfbedcb36cba95ab93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a43d5511608783dd26360601fb527addd87cf227affd6aac5a506c4af596e59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a43d5511608783dd26360601fb527addd87cf227affd6aac5a506c4af596e59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a43d5511608783dd26360601fb527addd87cf227affd6aac5a506c4af596e59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "808504387108186f2cd96444eaf273c63fc065787a7315eb2675184887068975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "808504387108186f2cd96444eaf273c63fc065787a7315eb2675184887068975"
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
    # The first `node` launch on macOS CI VMs can spend 20+ seconds in dyld
    90.times do
      break if output_log.read.include?("Failed to authenticate with Hugging Face API")

      sleep 1
    end
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end