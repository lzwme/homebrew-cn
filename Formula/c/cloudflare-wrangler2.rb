require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.65.0.tgz"
  sha256 "23fed63370e1c473ea97136ef7f03cadd6d7c0d994bfcd9917881b88e6ce03e4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a52188fe941c7943c2cfeb4368e4cf33a9eb852f028c3507276571c5df78f9a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a52188fe941c7943c2cfeb4368e4cf33a9eb852f028c3507276571c5df78f9a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a52188fe941c7943c2cfeb4368e4cf33a9eb852f028c3507276571c5df78f9a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "13912978f396dbdfe9fb32dcd096ce763fe34df995d0cb1c5f067ef102670017"
    sha256 cellar: :any_skip_relocation, ventura:        "13912978f396dbdfe9fb32dcd096ce763fe34df995d0cb1c5f067ef102670017"
    sha256 cellar: :any_skip_relocation, monterey:       "13912978f396dbdfe9fb32dcd096ce763fe34df995d0cb1c5f067ef102670017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5f53e2a6bf7d7d5c81907a704ad702bec013787e5e0db8cd4fa9744ebc544ca"
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