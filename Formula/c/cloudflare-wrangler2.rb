require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.5.1.tgz"
  sha256 "9c73ca8c5e2f90351081bb8f83fe27089bbede94ccc75b97bdebe0f1c36cfc72"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb41b2092ef1f93baa6d8f385abdfa11a53209fb74a2333073069e1897a78792"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8788d7cb6a4860816108e4016e59ddc0947903dae540c8bd80ec9584c2418227"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac99f781ef414d77593a1776c4b9c3b0132d674b3035c314b655fb77113da9d4"
    sha256 cellar: :any_skip_relocation, ventura:        "97bae65c912b097c70a858e1ec7b89d8608b379aa66f3cae86a8f242c26e2a72"
    sha256 cellar: :any_skip_relocation, monterey:       "6969dd501ceac9e6d9f19f6134ec94310b756136ebc1d7c5bc966538ba45a072"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3773144034fedc900739d17dac7684f3036c30e21f2c506c5a9433a7d8c657c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304e9d5e845ad08667632e5d2541259dc369ee38c0f27796d1eb99ee195f1f5e"
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