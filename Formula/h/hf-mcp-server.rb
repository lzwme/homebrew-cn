class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.15.tgz"
  sha256 "99abf5bac405ef5e23ba5640ae55ac313503224ac7a2d9e150ffe877cf070cd7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85c7eb4b40af7b0ee01cfbcc3d388bdcad561b7605642ae01460490b76019e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85c7eb4b40af7b0ee01cfbcc3d388bdcad561b7605642ae01460490b76019e7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85c7eb4b40af7b0ee01cfbcc3d388bdcad561b7605642ae01460490b76019e7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13a2721976729d108bd46c6b36294ff92588a8c41d3375abef63ad6283337d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13a2721976729d108bd46c6b36294ff92588a8c41d3375abef63ad6283337d33"
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