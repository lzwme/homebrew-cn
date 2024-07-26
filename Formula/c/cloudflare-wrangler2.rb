require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.67.0.tgz"
  sha256 "449a8bdd99867888e0e984d987348402907fd4c42e4080f7e9e6586365696aff"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f562e9104b7a31fa8247fd4f9a57215937cadd84a3a5f24de5a28bfe5ae16854"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f562e9104b7a31fa8247fd4f9a57215937cadd84a3a5f24de5a28bfe5ae16854"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f562e9104b7a31fa8247fd4f9a57215937cadd84a3a5f24de5a28bfe5ae16854"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5ca2e005fb86ba1ac2787b71831e28660d77adbdd3284089cf4e065c4b9bd3c"
    sha256 cellar: :any_skip_relocation, ventura:        "d5ca2e005fb86ba1ac2787b71831e28660d77adbdd3284089cf4e065c4b9bd3c"
    sha256 cellar: :any_skip_relocation, monterey:       "55381d82b284dd6b891021145eca31fcfdf599af2061f50fda00d2f41f5220e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58523970b5189e0dc9abd3b5b865294a90012a3a13fc94295a129fba9a24f5db"
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