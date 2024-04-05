require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.47.1.tgz"
  sha256 "333420dbb112539143792b11642fa0737a664d56c238561848c6d19f195df2a5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccdf442f6297a4c8e6efa37026aff48c0e96b07b0228fb286b9140ba4108931c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccdf442f6297a4c8e6efa37026aff48c0e96b07b0228fb286b9140ba4108931c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccdf442f6297a4c8e6efa37026aff48c0e96b07b0228fb286b9140ba4108931c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5afd8943e9df3f972651d9304a8ce7cbbfde2d87502a207f546dc76532892ad"
    sha256 cellar: :any_skip_relocation, ventura:        "c5afd8943e9df3f972651d9304a8ce7cbbfde2d87502a207f546dc76532892ad"
    sha256 cellar: :any_skip_relocation, monterey:       "c5afd8943e9df3f972651d9304a8ce7cbbfde2d87502a207f546dc76532892ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52feed244e9118ca9f3c406c8c7eb50909dd451fdafd6a51a5a7f106731dd106"
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