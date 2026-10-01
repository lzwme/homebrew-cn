class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.24.7.tgz"
  sha256 "64430248ab6e996fc0c6b9a0789361f868c3b97f83d16210e0424e51dffc5fa9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6ee739c86257b9df5163235c733df7b68f5e6280d688585358d4e5ced7687eda"
    sha256 cellar: :any, arm64_tahoe:       "6ee739c86257b9df5163235c733df7b68f5e6280d688585358d4e5ced7687eda"
    sha256 cellar: :any, arm64_sequoia:     "6ee739c86257b9df5163235c733df7b68f5e6280d688585358d4e5ced7687eda"
    sha256 cellar: :any, arm64_linux:       "16ce10c7f3ddaa1786d8fd8f1a04f5a1219284f510022ca743728e9c06059082"
    sha256 cellar: :any, x86_64_linux:      "c4da70c9a96abe5fc6004f3916be0f2c2641f2438b08ce897c922fb84159c655"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

    qwen_code.glob("vendor/landlock-run/*-linux").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}"
    end

    qwen_code.glob("node_modules/@qwen-code/audio-capture/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end