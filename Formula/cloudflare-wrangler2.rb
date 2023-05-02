require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.18.0.tgz"
  sha256 "0027d75f33a8cb8c3c7b29c9b17932f6c5b1f366906ff17a4a3b8f4c88759de3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aecf3a3c54919a30663eea8f5fbb43602b64d2e028be299a256fc9c398e29818"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aecf3a3c54919a30663eea8f5fbb43602b64d2e028be299a256fc9c398e29818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aecf3a3c54919a30663eea8f5fbb43602b64d2e028be299a256fc9c398e29818"
    sha256 cellar: :any_skip_relocation, ventura:        "88b1e05da1620807b2efa7cecc2f2227c7ad4648b5a0c828015ecce716a4427d"
    sha256 cellar: :any_skip_relocation, monterey:       "88b1e05da1620807b2efa7cecc2f2227c7ad4648b5a0c828015ecce716a4427d"
    sha256 cellar: :any_skip_relocation, big_sur:        "88b1e05da1620807b2efa7cecc2f2227c7ad4648b5a0c828015ecce716a4427d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82f40f0019db90364056f742a1b3865c1b581dadd0ffd5362f1799b0d282faf"
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