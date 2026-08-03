class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.5.tgz"
  sha256 "d5e8ef4c595eb44dc43110f98a400c1a6cb681763add3a7244776611a1c63557"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b513164f9f41131c40874e5b75d9772c5dd05edd605d9bba9631f587493a2c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b513164f9f41131c40874e5b75d9772c5dd05edd605d9bba9631f587493a2c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b513164f9f41131c40874e5b75d9772c5dd05edd605d9bba9631f587493a2c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1693d428a3a5dbe9dd8c314f5430753bbac98b0fdcef8280ab706fa9df246099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "839acb31c3ec4f2ef45e82ab6be12de3d9ddea3b4562fecfb5c216c5a49674f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "839acb31c3ec4f2ef45e82ab6be12de3d9ddea3b4562fecfb5c216c5a49674f3"
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