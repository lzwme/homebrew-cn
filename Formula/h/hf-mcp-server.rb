class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.19.tgz"
  sha256 "365c14850e19d5b217b783037213b0f7c1cbdb14b5f82c5e0679494d6df5a3a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a853cbafc998349715692e040cd0a70d5e47f8abcfa884efc68e35f34976fe90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a853cbafc998349715692e040cd0a70d5e47f8abcfa884efc68e35f34976fe90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a853cbafc998349715692e040cd0a70d5e47f8abcfa884efc68e35f34976fe90"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c223ac368e4ce934f76ac883dad2d3b7e8b6a810769f93dd99bd98addcd2c747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c223ac368e4ce934f76ac883dad2d3b7e8b6a810769f93dd99bd98addcd2c747"
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
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end