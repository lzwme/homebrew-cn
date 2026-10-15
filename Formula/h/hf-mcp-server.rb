class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.30.tgz"
  sha256 "1c52dfaa87619ffe276cdf4f139dfd85025bbaacfdedbb2dd6bbced0c4fd34d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93738a6e002e5ee16e1101829e5ebd9e38c3b147ed7b01d0953983f431a54342"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93738a6e002e5ee16e1101829e5ebd9e38c3b147ed7b01d0953983f431a54342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "93738a6e002e5ee16e1101829e5ebd9e38c3b147ed7b01d0953983f431a54342"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7a0cd89535d611db82f2921dbe840c304b0b88e18634a44f90b998a007317748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7a0cd89535d611db82f2921dbe840c304b0b88e18634a44f90b998a007317748"
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