class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.83.0.tgz"
  sha256 "d9081aa77c4ba79b25dcb941bdf6f2efe46137b8c1e0ae3e7eac1b35c65152dc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f5fb4949ebf76e36217fb2da812a3a9e4fe584ba9787625f5c300f1f234d90b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f5fb4949ebf76e36217fb2da812a3a9e4fe584ba9787625f5c300f1f234d90b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f5fb4949ebf76e36217fb2da812a3a9e4fe584ba9787625f5c300f1f234d90b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fec5c04e8fafafdd86452fbc6f3f388dc7531904f1b3bf999b2521986018fa89"
    sha256 cellar: :any_skip_relocation, ventura:       "fec5c04e8fafafdd86452fbc6f3f388dc7531904f1b3bf999b2521986018fa89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "287a8c2b3bb97b23203ee84f08c2ed63c3cdb45f2884b6afcb83d472ff2382e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end