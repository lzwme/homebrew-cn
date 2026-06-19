class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.18.3.tgz"
  sha256 "41ca0ee791130e04e984b6e1cefef170a73f3c10bfb0c42444f4ba0b68cf5e20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2da6c2657851e740686ae95a2fdfcfd749c3a1c268fc62a8807c943d05fba4a"
    sha256 cellar: :any,                 arm64_sequoia: "23a8dec048efa621367ce8559f7dd19e3302ace7f312e09f730dfc0df0b510b3"
    sha256 cellar: :any,                 arm64_sonoma:  "23a8dec048efa621367ce8559f7dd19e3302ace7f312e09f730dfc0df0b510b3"
    sha256 cellar: :any,                 sonoma:        "749819fc30a132ee2d3b9243400e0ee7e01e177510034e971c3dd5816a29197e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b190c7f0623cbadd557494e8480d1fcbc1bbd237b2cdf8a00741fc69b8380f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1ee0b2c9dcda79e1d166e1262fcec7089f70549350b07dc1bac2d18c343e2ce"
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