class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.92.0.tgz"
  sha256 "717b84ae0092b320c5b7d26e9ebd9cc95c261b4b4b56ad064a6aeeb93497fcf5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5fabfebbe4c919cd03cada58431a2e7856a95de1ec3750c6503eee6b886a042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5fabfebbe4c919cd03cada58431a2e7856a95de1ec3750c6503eee6b886a042"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5fabfebbe4c919cd03cada58431a2e7856a95de1ec3750c6503eee6b886a042"
    sha256 cellar: :any_skip_relocation, sonoma:        "82703955a00b51b4dd536fb5d774fcc1d0f9f4541ece6f426fe79d1610b22bd6"
    sha256 cellar: :any_skip_relocation, ventura:       "82703955a00b51b4dd536fb5d774fcc1d0f9f4541ece6f426fe79d1610b22bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06425487ce0eba1d660d57c74788358811acc1b0c320a6122800d8ef424e1679"
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