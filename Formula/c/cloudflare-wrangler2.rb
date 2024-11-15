class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.87.0.tgz"
  sha256 "3278bc3f8d15329c1396aef6f47dbddb1232772229aede3c0e7d772c707dc270"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf885d846527f151253195a0f134292b2fcb479cbf0d2206f2dc3b825ffd6a1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf885d846527f151253195a0f134292b2fcb479cbf0d2206f2dc3b825ffd6a1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf885d846527f151253195a0f134292b2fcb479cbf0d2206f2dc3b825ffd6a1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dcc50abf1d9db9c76f17f1562ce0658a68dd7e5085be9455c1e6b071c38af16"
    sha256 cellar: :any_skip_relocation, ventura:       "0dcc50abf1d9db9c76f17f1562ce0658a68dd7e5085be9455c1e6b071c38af16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1529380392806d20e9bb982acb445d65717fe28194af9c1d312f7e5c389d130d"
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