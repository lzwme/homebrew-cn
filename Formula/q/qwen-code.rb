class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.13.tgz"
  sha256 "d7347db0b25c42b621517ceb305a1c01320a38cc9eb4e9d790ab5da0df5a7581"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "a7501c88e6bd3bf214f6ecebb5b5c9096300e47c77603bd170ee361bae942596"
    sha256                               arm64_sequoia: "5525dd7127e5caa7a2364ed786a7e4ecf338dcb1022ac2b986a25c3cbb987dc0"
    sha256                               arm64_sonoma:  "4b03210971381a1dc753abcdef7fc649a95036424889693fdaee7b50c5aaf806"
    sha256                               sonoma:        "25508cf39285ad21a8eff699f60d62c2ca3b0199570374c1de2257a806c153f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed69d2f85d4fecac150be8e682a416192411254918783a6b83df84100cba65e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2088519c0653387a23756b69a7ca41ab5507ea97d496ed469a32233582eec82"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end