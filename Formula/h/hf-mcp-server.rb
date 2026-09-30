class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.24.tgz"
  sha256 "9ff9cb7501f3521a392be59b4b3b7e91297e975548a738889402e12559212700"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08dabea0f795e6fb8c56d11299c9956cbe2cd4d6f1a9cb842386f8083baa5fa2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08dabea0f795e6fb8c56d11299c9956cbe2cd4d6f1a9cb842386f8083baa5fa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08dabea0f795e6fb8c56d11299c9956cbe2cd4d6f1a9cb842386f8083baa5fa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0cf0dbf34a8ba48ac5cdca9e1457c9575c232e21eb360288e466285d79c85cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0cf0dbf34a8ba48ac5cdca9e1457c9575c232e21eb360288e466285d79c85cb7"
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