class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.1.2.tgz"
  sha256 "25ca6768565520c992373ea413c3bfd783d411f9f24d14018dd88a1f0baae7e7"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "20c5cc6d01d1ee6c5172df6c523fa62c95c085b6f465a4cce20fe1c8d401804a"
    sha256                               arm64_sequoia: "df22cda214cc7d542e7f57148048d66ef00e30a1cad817ccf6ed683dcd230bb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b6ca9c3cb3c45bc8978f30a9ed1a65f453d6d6e2e58d0cf5594dba7a179748d"
    sha256 cellar: :any_skip_relocation, sonoma:        "710029c6e5437627a00fa46e1ad0092b925a864aa038ccdbe5adea49b6fe59c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41742fd23182513b056c92a0d8f4bbf474c3d23d4cfdda063d6d22b675531e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39c2342622b9cfef2fd3e4f48b13b0e1a712d95c3aed0baa3ecf9fadfa9bce76"
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