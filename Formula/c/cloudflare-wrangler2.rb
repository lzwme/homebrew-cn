require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.66.0.tgz"
  sha256 "db1689faad91560797dd331025f5e2d33525350b59e9139d4ac0a1f3e4e6d2c8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e28458a9da33beb99f8ec72ce0398eaab75bdcbf82529673022b941072d47f37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e28458a9da33beb99f8ec72ce0398eaab75bdcbf82529673022b941072d47f37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e28458a9da33beb99f8ec72ce0398eaab75bdcbf82529673022b941072d47f37"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8fb3dd7f4e1a5713ce1da6c92bb94134a8089ac44761e6276443f342929d5ca"
    sha256 cellar: :any_skip_relocation, ventura:        "a8fb3dd7f4e1a5713ce1da6c92bb94134a8089ac44761e6276443f342929d5ca"
    sha256 cellar: :any_skip_relocation, monterey:       "9b8699d209a565fe79116c62da5ce0af37e33935ba548daac3f3ee1d457d1cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ac77412bc00d5ff1af1a12e89a5e06ea3a34806d5bd8429fe775c4d9b4b058e"
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