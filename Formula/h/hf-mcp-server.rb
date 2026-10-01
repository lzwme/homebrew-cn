class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.25.tgz"
  sha256 "9c6b164e420d7e16b1fe2ba1cbae5a292dcb650768d85d1ff2c6a9936c323531"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39430b79b9bc194623dbda8eb0f5b93513a2bc80c00ca5d3a096775ce988c946"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39430b79b9bc194623dbda8eb0f5b93513a2bc80c00ca5d3a096775ce988c946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39430b79b9bc194623dbda8eb0f5b93513a2bc80c00ca5d3a096775ce988c946"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2408b6d8d7415f8e087d4a2857dc65291a23b57d10b1ccbc698b4098950a6987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2408b6d8d7415f8e087d4a2857dc65291a23b57d10b1ccbc698b4098950a6987"
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