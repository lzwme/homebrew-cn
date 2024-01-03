require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.22.2.tgz"
  sha256 "c1ce957d49986bb93afa0bf49466761d986e4437817ea4e702681d09d73b5729"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99b92d486e151c38833f04f5b8b31e8871742742d21d2f5e207ffaf5ca36cfc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99b92d486e151c38833f04f5b8b31e8871742742d21d2f5e207ffaf5ca36cfc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99b92d486e151c38833f04f5b8b31e8871742742d21d2f5e207ffaf5ca36cfc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d07745e5f53b03ee24ab3e68d680287aecdcc19e2783e7ede9a5dbb7c0004fe3"
    sha256 cellar: :any_skip_relocation, ventura:        "d07745e5f53b03ee24ab3e68d680287aecdcc19e2783e7ede9a5dbb7c0004fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "d07745e5f53b03ee24ab3e68d680287aecdcc19e2783e7ede9a5dbb7c0004fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fd89e5c9aa3007424ab9737a4a10884843cef58adb73d149895730ddf2a9af0"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}libnode_modules***"]
    bin.install_symlink Dir["#{libexec}binwrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec"libnode_moduleswranglernode_modulesfseventsfsevents.node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end