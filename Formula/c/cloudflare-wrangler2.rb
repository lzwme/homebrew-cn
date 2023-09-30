require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.10.1.tgz"
  sha256 "0bed44b080e8f6ae365329c3db958333b4d2f494e1675aa9280a6e02574f4810"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "199af9c6b4f0f5592fd5e28ed1824be98d3825f0178c2ca0c86df90ea0deef41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "199af9c6b4f0f5592fd5e28ed1824be98d3825f0178c2ca0c86df90ea0deef41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199af9c6b4f0f5592fd5e28ed1824be98d3825f0178c2ca0c86df90ea0deef41"
    sha256 cellar: :any_skip_relocation, sonoma:         "f418ddb3b18c15304fee66345bd25b1a743ad90a7f76a829bdfd6a855f1ecf31"
    sha256 cellar: :any_skip_relocation, ventura:        "f418ddb3b18c15304fee66345bd25b1a743ad90a7f76a829bdfd6a855f1ecf31"
    sha256 cellar: :any_skip_relocation, monterey:       "f418ddb3b18c15304fee66345bd25b1a743ad90a7f76a829bdfd6a855f1ecf31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10d469a779020236808ada87366c54dfc236bac6efd419d9daa1b078f6f2c3ba"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/wrangler/node_modules/fsevents/fsevents.node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end