class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.5.2.tgz"
  sha256 "c512f93fc0110e013cb623569a5542ec5f08c0634e65fc3ad9eda2b33ef9a1a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3215869cee5d7bbdd51345177c918a2b4e87bbe6aed27966d5aca536e4e0e6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3215869cee5d7bbdd51345177c918a2b4e87bbe6aed27966d5aca536e4e0e6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3215869cee5d7bbdd51345177c918a2b4e87bbe6aed27966d5aca536e4e0e6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0862556061e1bd5827d316d457891ae96bcc39e858dd86ac826a601cfb9020a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1adf875dfdede4e0c5a6f665dfcc022b8703254b89258d72f2824e26d8371672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8769c688737a814c1d329a3251b93c72b92a11400841d4555a84ff4124e22ad8"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    rm_r(libexec/"lib/node_modules/@qwen-code/qwen-code/vendor/ripgrep")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end