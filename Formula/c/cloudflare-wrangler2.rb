require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.13.0.tgz"
  sha256 "b108092ba3b0210d17a16eb99ea3c682f4221cf1e3482640d948a666b27e725d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3df673145b350dfac670ade9c84eef27a875587a9bb41960f3a01798e4ef354"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3df673145b350dfac670ade9c84eef27a875587a9bb41960f3a01798e4ef354"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3df673145b350dfac670ade9c84eef27a875587a9bb41960f3a01798e4ef354"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6619fe6215829499e80086c21d30c7fef8736be55679f16f7ba59d1b0a8ae1e"
    sha256 cellar: :any_skip_relocation, ventura:        "a6619fe6215829499e80086c21d30c7fef8736be55679f16f7ba59d1b0a8ae1e"
    sha256 cellar: :any_skip_relocation, monterey:       "a6619fe6215829499e80086c21d30c7fef8736be55679f16f7ba59d1b0a8ae1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0a210d4a8b42190b87d56beae289da2ba185d0d5a99884d36dc111779d219d"
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