require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.52.0.tgz"
  sha256 "ecdd056ae97c5c68d259bc865f01528007bc2b7a5b62e02e49e63a4dfb25bcbd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b175d62d1b5d64cd9bde4f82e5231934ff0508f28344ba89d5d42a24b34679e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b175d62d1b5d64cd9bde4f82e5231934ff0508f28344ba89d5d42a24b34679e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b175d62d1b5d64cd9bde4f82e5231934ff0508f28344ba89d5d42a24b34679e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e6fc016788361fb9cf1d6ff5600c5695cd2bc6295bbe5228d8c2e8c9ac20f3e"
    sha256 cellar: :any_skip_relocation, ventura:        "4e6fc016788361fb9cf1d6ff5600c5695cd2bc6295bbe5228d8c2e8c9ac20f3e"
    sha256 cellar: :any_skip_relocation, monterey:       "4e6fc016788361fb9cf1d6ff5600c5695cd2bc6295bbe5228d8c2e8c9ac20f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51f8c8d250fdcc41847d2527d6d89144c1a17380998c9a1da3e93b745406e192"
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