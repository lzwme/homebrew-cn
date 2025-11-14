class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.2.1.tgz"
  sha256 "1ad1015a788198236ac04ea64784acf15191c195760a840817a140e2337380cd"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "64e1887456dfe8ff4513fda3edec0ccd2b4c6de47a53f0c3cb51adea6a9fd6c6"
    sha256                               arm64_sequoia: "d19206917860df2729ad8038e8d146da6962f71b05a2d9a31870851bf754358f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abe809cb8691816e2470915976185e5787d876feaa06c25ee016fc6c45332de9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffd433d5a2fa7e17b56dacb1007d89ab112fa585fd1133526424ea40e46170dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a763cd48b323bedcc4b578425b66199036504ed28f918caf6f9ba284e965f7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb8fd9543e987e43dd49977b0faf3605b82d377646efb5a2248c92fb28fd1967"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    rm_r(libexec/"lib/node_modules/@qwen-code/qwen-code/vendor/ripgrep")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end