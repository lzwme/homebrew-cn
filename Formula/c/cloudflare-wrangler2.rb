require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.20.0.tgz"
  sha256 "433595e4936f849bc52f68eea6a0f403a69586e1963758a6d01a991cb49a2282"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cb82d3f64bec08fd75d51dd9bd934c7d94c55e5acdbc7dfef14be683f2aded1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cb82d3f64bec08fd75d51dd9bd934c7d94c55e5acdbc7dfef14be683f2aded1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cb82d3f64bec08fd75d51dd9bd934c7d94c55e5acdbc7dfef14be683f2aded1"
    sha256 cellar: :any_skip_relocation, sonoma:         "81c2fdd4d2209947b78e0a2ab486e84301440ef97a7839287bd7de11f7a1f584"
    sha256 cellar: :any_skip_relocation, ventura:        "81c2fdd4d2209947b78e0a2ab486e84301440ef97a7839287bd7de11f7a1f584"
    sha256 cellar: :any_skip_relocation, monterey:       "81c2fdd4d2209947b78e0a2ab486e84301440ef97a7839287bd7de11f7a1f584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a158996a5f135b1e3aa4ad4844c03a2f1f446821043fa2412f7e3ad02c04978e"
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