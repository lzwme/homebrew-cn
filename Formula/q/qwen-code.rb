class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.6.tgz"
  sha256 "e1b2e9ae8613dca373d3c7ce4eeae2f07091e64fa9b07a7af1dfda0d83cfbf39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e51a39c23f888b99763998ede67590b71881ce2a49db4102ff7f09b93c1571c"
    sha256 cellar: :any,                 arm64_sequoia: "cd0d92825202cf48c80f06ff1d3b42f79c663b1921553062fc41f1a2fad88faf"
    sha256 cellar: :any,                 arm64_sonoma:  "cd0d92825202cf48c80f06ff1d3b42f79c663b1921553062fc41f1a2fad88faf"
    sha256 cellar: :any,                 sonoma:        "9cf88752a90ef71733ee4cd8e1925b142f6f4a5bf393681d75f5a74376276e10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ecfc391782ae26da9c1281e17f38a1824707f4682cc036fdd6f97a4bf2cb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf4482ee31514864c8e84e0378671232a2a8ae7f1f430e1df274749f9e2b941"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end