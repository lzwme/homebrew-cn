class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.23.tgz"
  sha256 "1b9fb84c3ff2174a71daaeab362eb7cb45ab767d169e6ce490dcc3e7af255ab1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d752fb624fced440468d7eeab689818f2e90a7daa2568dcdd1aa327476ca04d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d752fb624fced440468d7eeab689818f2e90a7daa2568dcdd1aa327476ca04d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d752fb624fced440468d7eeab689818f2e90a7daa2568dcdd1aa327476ca04d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ff4fde7a0fcdc3ae7fcfd443dfc309b5c696cbdab9a1d85a089a9a4d9c475939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ff4fde7a0fcdc3ae7fcfd443dfc309b5c696cbdab9a1d85a089a9a4d9c475939"
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