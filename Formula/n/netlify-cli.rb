require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.0.3.tgz"
  sha256 "715694b7238be7ecc654640319d76bcfa13d7644c61a067633e81992d950e1d8"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "82739f87aaeafc77b370202178bd19a8dc035597f55d06c6fddb83a2256e77ed"
    sha256                               arm64_monterey: "e6cd71c4d9bdc4a47daad56fa0048564b2b878d0c4700d666c65912a1d698881"
    sha256                               arm64_big_sur:  "cacf6f53b8d885b259bddc64fc51f4cc211cbdd0258259b0c4bca12c421f5d53"
    sha256                               ventura:        "4ce5b2dda805e80fe3a4e1fc9993d01c7c2a3ed28d82c8f782db1de3d62ed41e"
    sha256                               monterey:       "9fab584f4122c41724107eda12065d2e0acbd2c419e62599cc42f6a0e19a64cd"
    sha256                               big_sur:        "3ba13447c6e15f9e251a2dec4f235ecd00c0b3a9cb733565393dc49d8fcf1117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd91d9548dfc8d5bffc585255e0105d4ee8cc0a8af0bd7cc6139a8627a473547"
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