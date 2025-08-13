class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.29.0.tgz"
  sha256 "bef95e1b64530214511384ab06aec99718d7752eda999ab495bac259b06127cb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a5e92ee8a390c366ae23a479763b82a873d4b841eaa07909036490989e448a8"
    sha256 cellar: :any,                 arm64_sonoma:  "5a5e92ee8a390c366ae23a479763b82a873d4b841eaa07909036490989e448a8"
    sha256 cellar: :any,                 arm64_ventura: "5a5e92ee8a390c366ae23a479763b82a873d4b841eaa07909036490989e448a8"
    sha256                               sonoma:        "5ba1f8c2118d80c1df5b334e882572e912cb4e5a079ac1fb563fd4f71e7da12e"
    sha256                               ventura:       "5ba1f8c2118d80c1df5b334e882572e912cb4e5a079ac1fb563fd4f71e7da12e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2929c6ad9e68b8f6ff19856ef79125ac7be108baffb1047c48fa5afabe6f917e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a28e0ab52217024de73bd94235ccc6a365e169e3b622ab7b2bde595076c3672"
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