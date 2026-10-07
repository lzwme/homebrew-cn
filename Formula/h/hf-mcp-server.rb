class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.28.tgz"
  sha256 "bc309cd2c2978279c33089bb2cfac714ed942d554045336df140d31dfec85910"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dfde17ef289c1ab9311201f818eb8eebd8b4cad2448b9abf5389a465326f324f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dfde17ef289c1ab9311201f818eb8eebd8b4cad2448b9abf5389a465326f324f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfde17ef289c1ab9311201f818eb8eebd8b4cad2448b9abf5389a465326f324f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b635312d7d4fcdf6b501e7d989e1ab91fc3c265e1131b129123f1246c5439757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b635312d7d4fcdf6b501e7d989e1ab91fc3c265e1131b129123f1246c5439757"
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