require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.19.0.tgz"
  sha256 "0685e6f7dede3f8f5656f3d020a6ce9a975ebd4d530bb04f910eb86c8b1b5983"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb5ef7cf827f5b61cb89d3db0148d3958641abe14fd0446543d62a7503e27ce3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb5ef7cf827f5b61cb89d3db0148d3958641abe14fd0446543d62a7503e27ce3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb5ef7cf827f5b61cb89d3db0148d3958641abe14fd0446543d62a7503e27ce3"
    sha256 cellar: :any_skip_relocation, ventura:        "ba01b5a4e4adad6549f749cac17c8ee8e4dc0514bc8b321aad956ab474cd8c86"
    sha256 cellar: :any_skip_relocation, monterey:       "ba01b5a4e4adad6549f749cac17c8ee8e4dc0514bc8b321aad956ab474cd8c86"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba01b5a4e4adad6549f749cac17c8ee8e4dc0514bc8b321aad956ab474cd8c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a023d558523b390d8870785d169c1e063e31510930fa9281ec9287813c6a749"
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