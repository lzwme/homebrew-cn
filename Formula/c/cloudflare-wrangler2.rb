require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.16.0.tgz"
  sha256 "98426c5a00dbc7bfd2dbd2b9b262bffc86f87171850cf3ff369a8f98dc14728b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bb3a110d69b815c8c96ce09affcb11ffe5a568481621487fe3b9b037f2b18f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bb3a110d69b815c8c96ce09affcb11ffe5a568481621487fe3b9b037f2b18f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bb3a110d69b815c8c96ce09affcb11ffe5a568481621487fe3b9b037f2b18f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6e7dfe6ef2dc474857ea5e0609ff78b13a3334a773d3626b7312f26383645e8"
    sha256 cellar: :any_skip_relocation, ventura:        "e6e7dfe6ef2dc474857ea5e0609ff78b13a3334a773d3626b7312f26383645e8"
    sha256 cellar: :any_skip_relocation, monterey:       "e6e7dfe6ef2dc474857ea5e0609ff78b13a3334a773d3626b7312f26383645e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c536c05b2798a44d6de88ece846d649214a9ae15bbc4d915c89af6fba4f73092"
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