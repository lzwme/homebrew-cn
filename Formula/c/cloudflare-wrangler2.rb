require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.61.0.tgz"
  sha256 "91cdc1472c9c9dc426b4b36b86ee7267cf65f7104a101bc171c717b91817f791"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "096eda35b8e795ff50e65fba33638d9314cc069402ac1c37bd9ca06f315c0978"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "096eda35b8e795ff50e65fba33638d9314cc069402ac1c37bd9ca06f315c0978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "096eda35b8e795ff50e65fba33638d9314cc069402ac1c37bd9ca06f315c0978"
    sha256 cellar: :any_skip_relocation, sonoma:         "350882dccb2f8a5ba8fd58c221c475d3db429fd21a5e3b86ec6475c86e0fe412"
    sha256 cellar: :any_skip_relocation, ventura:        "350882dccb2f8a5ba8fd58c221c475d3db429fd21a5e3b86ec6475c86e0fe412"
    sha256 cellar: :any_skip_relocation, monterey:       "350882dccb2f8a5ba8fd58c221c475d3db429fd21a5e3b86ec6475c86e0fe412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c497ba739c0ac2d764e2d6e339aa63a9e002684da6ee7836f403febcd6a44b"
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