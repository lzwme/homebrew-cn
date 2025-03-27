class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.5.0.tgz"
  sha256 "3b446ec6c43f4f8ddbaa4dddc64b7caad5d52cb68076ded2ec089f6ac4649854"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c80309e8a0e9bd332eb47f2dac19bace8eb99594b8fc60413f41b817141a3a1e"
    sha256 cellar: :any,                 arm64_sonoma:  "c80309e8a0e9bd332eb47f2dac19bace8eb99594b8fc60413f41b817141a3a1e"
    sha256 cellar: :any,                 arm64_ventura: "c80309e8a0e9bd332eb47f2dac19bace8eb99594b8fc60413f41b817141a3a1e"
    sha256                               sonoma:        "51911f0eaacfac9d37204044a10fa51e695335642e1fdba4f1229691dca146f4"
    sha256                               ventura:       "51911f0eaacfac9d37204044a10fa51e695335642e1fdba4f1229691dca146f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1217dd49d3c695511d3b9d4858379b64bbebb7f65be61a31e56ad1b67627b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac514308782ddfd61715b811bfff641184e9b9e46425045395c587d1ea03b38"
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