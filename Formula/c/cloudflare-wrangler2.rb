require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.7.0.tgz"
  sha256 "bd9d64f986bc2202a2d9ded566bde3b21eceed181e9a3f84cd8a153518ed7d9e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59895eb7dea237dffc340a2a81f80f6ade5f64cacdc26825ec19717cf4d0f0d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b7795f5179ea7d4ee977f956dbb47f5ad4ed715209b90ffa3cdf517464afe2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e9020d449c4eb0b95f81a32ea97404d332b678878ecfb9c94dd624aee337f8d"
    sha256 cellar: :any_skip_relocation, ventura:        "d8b8a0cb4812b5543b39fc8e24bf49b200adc0af273c145bc5c9a308601d0a8f"
    sha256 cellar: :any_skip_relocation, monterey:       "c2c927863b7c1c1a036a3b0b2e13fc03b396431c1cd22e0937e3092380693e6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0bfc128afe055957b2119c7bab86e3f7ae8d9c842a2a59ddb596ccd403d6717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c03b5c9106a185efe0e22d389e5c4b02e8000517f727d91c4f60c82c1e59598"
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