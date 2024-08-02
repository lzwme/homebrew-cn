require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.68.0.tgz"
  sha256 "374a128e48f9455320de285d5ca95a40abc40c4e2bf5bbea7a86bd3a7e3c62dc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "083e9c12247e2cc7741e34455a3077ac5d693428f5fde49d765b52fbebcf4255"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "083e9c12247e2cc7741e34455a3077ac5d693428f5fde49d765b52fbebcf4255"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "083e9c12247e2cc7741e34455a3077ac5d693428f5fde49d765b52fbebcf4255"
    sha256 cellar: :any_skip_relocation, sonoma:         "d45c96429584f2d0e7bfac4864da609ba3712cbde3133267198207849f89f183"
    sha256 cellar: :any_skip_relocation, ventura:        "d45c96429584f2d0e7bfac4864da609ba3712cbde3133267198207849f89f183"
    sha256 cellar: :any_skip_relocation, monterey:       "d45c96429584f2d0e7bfac4864da609ba3712cbde3133267198207849f89f183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "334c699063e96ae2bc7ab2601d90e47434ebbe2e97a037674f22c03df3cf6008"
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