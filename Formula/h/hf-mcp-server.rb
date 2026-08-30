class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.16.tgz"
  sha256 "0166059fcd06b788901c70c031294867273c34fd1d8f31d819824192c936f0d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddc6314967212a19e483dc72b27ae87c6962afd9fc8ae1fe79a72f653824b819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddc6314967212a19e483dc72b27ae87c6962afd9fc8ae1fe79a72f653824b819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc6314967212a19e483dc72b27ae87c6962afd9fc8ae1fe79a72f653824b819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "526d729e9870bfcbfe79a4a4de521e69b7bab8ba6720c60a55431eba3dc83193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "526d729e9870bfcbfe79a4a4de521e69b7bab8ba6720c60a55431eba3dc83193"
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