class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.4.tgz"
  sha256 "5140b7e3ae6d96be6cddb2450bd37e1e45ca285a1f9936f94873b0569463aadc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a60c3d30d409daa0dbc27935c9c1b2b20a0fe0c0a5a6782da54b00b5efd54018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a60c3d30d409daa0dbc27935c9c1b2b20a0fe0c0a5a6782da54b00b5efd54018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a60c3d30d409daa0dbc27935c9c1b2b20a0fe0c0a5a6782da54b00b5efd54018"
    sha256 cellar: :any_skip_relocation, sonoma:        "2971d0f47ec787e7a8f7439319b2caa3872b2fc79456c878a5ea6744fb6f6b83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00831f442dc5685b5a04254c89cf732e699145b4ec550acc8597c10e4f4c51a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00831f442dc5685b5a04254c89cf732e699145b4ec550acc8597c10e4f4c51a0"
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