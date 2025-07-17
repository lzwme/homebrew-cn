class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.24.4.tgz"
  sha256 "536226bda984949234c46732d4701cbb58d7cbffead2e663c862e40cf5967473"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6866ddc40f9c850d8baafc6d0648ed52e5de6e31e8fd14233d813c9ca9868356"
    sha256 cellar: :any,                 arm64_sonoma:  "6866ddc40f9c850d8baafc6d0648ed52e5de6e31e8fd14233d813c9ca9868356"
    sha256 cellar: :any,                 arm64_ventura: "6866ddc40f9c850d8baafc6d0648ed52e5de6e31e8fd14233d813c9ca9868356"
    sha256                               sonoma:        "11b2a163c1342c52fefad0208a63c863d753a5a22668117785cbfa4b4ac7f016"
    sha256                               ventura:       "11b2a163c1342c52fefad0208a63c863d753a5a22668117785cbfa4b4ac7f016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "125750e867c073bd35fc91caf4277921850a91fc04e72c9869679137b56711ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b27afa72ca4ee66cf22c90f87c16fb57eb39f805b0c8124ded046a049b0eda0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end