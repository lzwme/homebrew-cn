require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.15.0.tgz"
  sha256 "3dda1d5a14b4b14c6145257c8e6ef4edb61c34593f084462d56ec9f4b4337797"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69d54ffd751a543e2e34551f3cdcfaa954bda0574c5075f5a18085c4d51429d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69d54ffd751a543e2e34551f3cdcfaa954bda0574c5075f5a18085c4d51429d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69d54ffd751a543e2e34551f3cdcfaa954bda0574c5075f5a18085c4d51429d4"
    sha256 cellar: :any_skip_relocation, ventura:        "6d97ad049c9fe7ad46d9d38ec7f194c007fa410c353ede5ffc72b53db033984a"
    sha256 cellar: :any_skip_relocation, monterey:       "6d97ad049c9fe7ad46d9d38ec7f194c007fa410c353ede5ffc72b53db033984a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d97ad049c9fe7ad46d9d38ec7f194c007fa410c353ede5ffc72b53db033984a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "449edcc7cd5a345d46a8be9cc7ae37ff526f93677ea36eed2f11036819fd5ef8"
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