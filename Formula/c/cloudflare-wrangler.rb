class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.14.1.tgz"
  sha256 "5f1d14260778f99314fbe3f4792918b3805b7922881bc86de16e9a55c3cb4721"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cea82b3cf689e36bb8c67f2312171c8461f00c2c0c9590573eef1428d72abb8a"
    sha256 cellar: :any,                 arm64_sonoma:  "cea82b3cf689e36bb8c67f2312171c8461f00c2c0c9590573eef1428d72abb8a"
    sha256 cellar: :any,                 arm64_ventura: "cea82b3cf689e36bb8c67f2312171c8461f00c2c0c9590573eef1428d72abb8a"
    sha256                               sonoma:        "85940b79cd2620bf7b2fef290db47249038917889537975665b5ffdc0dc1edef"
    sha256                               ventura:       "85940b79cd2620bf7b2fef290db47249038917889537975665b5ffdc0dc1edef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b889497d08fdfb429b4395dc18ed39ef34ef85d2f76ea212b13a38f4acb2720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b98f89f3a15a303ef08b048e6b7a931a3b913060bd02d3eb5cd242935c0aa84"
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