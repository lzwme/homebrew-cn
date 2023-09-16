require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.3.3.tgz"
  sha256 "8439c78e83fc70ae3d32c4426e99187b2de681772b7259111f7ce619b675037b"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "368e4d48c78bfca596e8270a3f1570116b68f5e158daa2743ec26f1d4edcf88c"
    sha256                               arm64_monterey: "9210168ca354e6554a8c4f09ba7875e6bff25273514281d5df4e4c4f998974fd"
    sha256                               arm64_big_sur:  "c11a9914cf138e68a8d0a6d5d7c703f079ed86122aff3d13a5154ed8e1cf2a6f"
    sha256                               ventura:        "c00768411518a552a5c82c7a38bcc4df763348eec4bd2c75d9e19a73c24350fd"
    sha256                               monterey:       "a860804caa71d12593947e2324ba6825b89f57811e512b02a06fc5595cd622a5"
    sha256                               big_sur:        "a7fb18fe7b030dd369838f8fdd7bd67094897a25dda03ffeafd63640161e58a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7d2d1cb17b0417c808e17161e95d197941148c77276c55f6c1b2cf46bac89e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end