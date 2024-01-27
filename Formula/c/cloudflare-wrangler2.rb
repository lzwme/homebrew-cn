require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.25.0.tgz"
  sha256 "bdf754ce4065d3667a45ccd054e137bed100d8907b11d6118fde4d4356ccbe41"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6915a03b2fa8a46e780952cf68ea1ae57e32f84f00255ca4e4bd747d00815e16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6915a03b2fa8a46e780952cf68ea1ae57e32f84f00255ca4e4bd747d00815e16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6915a03b2fa8a46e780952cf68ea1ae57e32f84f00255ca4e4bd747d00815e16"
    sha256 cellar: :any_skip_relocation, sonoma:         "35d4e8f2e3bba79e0d1f120992d84fc856a8b83e4e073e0e8fb2b5254cc44218"
    sha256 cellar: :any_skip_relocation, ventura:        "35d4e8f2e3bba79e0d1f120992d84fc856a8b83e4e073e0e8fb2b5254cc44218"
    sha256 cellar: :any_skip_relocation, monterey:       "35d4e8f2e3bba79e0d1f120992d84fc856a8b83e4e073e0e8fb2b5254cc44218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f6b9dc25f890a9f250573370021bea8b7e000b5295d23b4e3e328f73d2cf928"
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