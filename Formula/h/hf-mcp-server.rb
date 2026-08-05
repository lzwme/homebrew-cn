class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.6.tgz"
  sha256 "646d329670397aba24f1867b81112c142ed1f1eea8a5902925992a56fbd9feeb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4508827496aabc212ce55e929e322cadaabb096c2301f21a6cc78c5ba64d95f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4508827496aabc212ce55e929e322cadaabb096c2301f21a6cc78c5ba64d95f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4508827496aabc212ce55e929e322cadaabb096c2301f21a6cc78c5ba64d95f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1658487d1d0f094a2afaf37079275c5514a358762e9f257a986582890108177d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef0286c45b0efc67c049c4f835bb9c20c50b33a709f8eb7e7661cf34445d4cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0286c45b0efc67c049c4f835bb9c20c50b33a709f8eb7e7661cf34445d4cca"
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