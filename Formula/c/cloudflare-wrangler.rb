class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.113.0.tgz"
  sha256 "03ef5298cb917c463166595edf7bba13cf0f1ded5b61d2814c52a7ede6091a3f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3ce6452479c6a3d34e73d53632d7b141c0f190a78e231837c4bdfbef6ed9275a"
    sha256 cellar: :any,                 arm64_sonoma:  "3ce6452479c6a3d34e73d53632d7b141c0f190a78e231837c4bdfbef6ed9275a"
    sha256 cellar: :any,                 arm64_ventura: "3ce6452479c6a3d34e73d53632d7b141c0f190a78e231837c4bdfbef6ed9275a"
    sha256                               sonoma:        "f37717e447e35ff5c08be2f757274cd473337ba9418edb0152126ada76002fe2"
    sha256                               ventura:       "f37717e447e35ff5c08be2f757274cd473337ba9418edb0152126ada76002fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54dab2f5a339977e206412c16ddb0c7323e65f8cdc85b28c487c2ed4fc66a3a"
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