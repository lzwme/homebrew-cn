require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.13.0.tgz"
  sha256 "ffaff80acd44b1be837d0bd0b418fe55ad4188e01bda9ddda7079dda41f9e662"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a49e4b0d51a1cbd47f9bdb41846f2fc709b4d2db33056f679c1cea135244fab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a49e4b0d51a1cbd47f9bdb41846f2fc709b4d2db33056f679c1cea135244fab0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a49e4b0d51a1cbd47f9bdb41846f2fc709b4d2db33056f679c1cea135244fab0"
    sha256 cellar: :any_skip_relocation, ventura:        "912952bbec525c45ab6e05a0a8b3e5375a9544835e4bc9cbfdb06cc47f6c0d4b"
    sha256 cellar: :any_skip_relocation, monterey:       "912952bbec525c45ab6e05a0a8b3e5375a9544835e4bc9cbfdb06cc47f6c0d4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "912952bbec525c45ab6e05a0a8b3e5375a9544835e4bc9cbfdb06cc47f6c0d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "093fb9fdccddf76cae6c57154c926511d5077e91074260423c049de60e8b67e1"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/wrangler/node_modules/fsevents/fsevents.node"
  end

  test do
    system "#{bin}/wrangler", "init", "--yes"
    assert_predicate testpath/"wrangler.toml", :exist?
    assert_match "wrangler", (testpath/"package.json").read

    assert_match "dry-run: exiting now.", shell_output("#{bin}/wrangler publish --dry-run")
  end
end