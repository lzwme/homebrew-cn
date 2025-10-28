class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.1.0.tgz"
  sha256 "81ccd19d0904d66aea4d61ea9f04ac20d2ecc91383ed9c9ebaeb2b314aeeb027"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "199c35dad015819a4b0f7dd54d2052550a61c2297e19f222be57eeba57470803"
    sha256                               arm64_sequoia: "dcea1507a0ff500d333ff8f8ae7b5f3c3367494d2bb5d110e13a7d4b2633053d"
    sha256                               arm64_sonoma:  "b7823340f00fcb2169bb30b97490547894a266e8881f66b839cccf9a529d8b85"
    sha256                               sonoma:        "2e32a325c95e783b2db0f203c4c4c6dd4efab209e143cede2501703b946fb614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7091c1cda35d98cc77d84de6a063a3437fafb8a4bd3dec8d373bfbfe0cae484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eeec4cc2aeb85b28ea7856c9cfb808ccc1ee05f02d9e8f6a9ff0f610af04c28"
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