require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.60.2.tgz"
  sha256 "e752c1785a0f74488eb1f4ef7376b77d488c8e76aa0aaadfa925d7fff675eb84"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "590c93501e88086a367c9df24bbfe639553a89d942957b4917aa9cf73d63c7c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "590c93501e88086a367c9df24bbfe639553a89d942957b4917aa9cf73d63c7c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "590c93501e88086a367c9df24bbfe639553a89d942957b4917aa9cf73d63c7c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4340585743ea8d24a73461f9914a569f438ee1cad2aa1ee06854e047973fca0"
    sha256 cellar: :any_skip_relocation, ventura:        "f4340585743ea8d24a73461f9914a569f438ee1cad2aa1ee06854e047973fca0"
    sha256 cellar: :any_skip_relocation, monterey:       "f4340585743ea8d24a73461f9914a569f438ee1cad2aa1ee06854e047973fca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcbf76ac33ce14f964b24b6c1b9fc4d64140e6526e35a0bdae1d6342977a3a0a"
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