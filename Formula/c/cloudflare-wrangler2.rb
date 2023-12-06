require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.19.0.tgz"
  sha256 "e63b6bda025de9185b373b4cc6723e084ecd84c275239560cf881e63af066698"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "301274dd2606ba3ee0eb71dfba1c230ba5bb72174f8f656f3d772a486aab464b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "301274dd2606ba3ee0eb71dfba1c230ba5bb72174f8f656f3d772a486aab464b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301274dd2606ba3ee0eb71dfba1c230ba5bb72174f8f656f3d772a486aab464b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f818e03184fedf1162c48b60d17b5168692575c24018b5760f8f20b284780bb"
    sha256 cellar: :any_skip_relocation, ventura:        "9f818e03184fedf1162c48b60d17b5168692575c24018b5760f8f20b284780bb"
    sha256 cellar: :any_skip_relocation, monterey:       "9f818e03184fedf1162c48b60d17b5168692575c24018b5760f8f20b284780bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba163b1694be688319e0f670fb3be4dc87234d836e8ffeb379898ac0604409a"
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