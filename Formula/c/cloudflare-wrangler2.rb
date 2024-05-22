require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.57.1.tgz"
  sha256 "9bcbfeff54797aae426e2a7994494b5e62f8a5a5aa630e77a35f306f00090baa"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "771982db671223efda1797198aa14e764de2773ad615da8eaf97ca34f235f3b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "062c47d2ce7bce7e25d7271b0d125ad5293ee8d22f110aceb42f1a4c022c9041"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49ebe17e4a4b2442ba692675c7ffd80ad9d8399a9a9575e4a8299f2bba271582"
    sha256 cellar: :any_skip_relocation, sonoma:         "f10bf6367c053f16797e4300495c506a3b459f2956d242d8e9ed3978622c2e8a"
    sha256 cellar: :any_skip_relocation, ventura:        "671dc0deeee4e65138adc9617446ac612d0c614513c0b350517924120d121128"
    sha256 cellar: :any_skip_relocation, monterey:       "b2495923cea305409e1bb7a4d395c180dd5bffa9535643abfb0e06c3e3fb3270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a672f4cd0007b0113c6484a7c33cf4a40a70858e69c97c6f9be68fb2df89ac11"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}libnode_modules***"]
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end