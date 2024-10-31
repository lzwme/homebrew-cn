class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.84.0.tgz"
  sha256 "3c202ec2635490a7b6661609c67e96f9b58c4ecfd2f6c28f6a979380f98e641c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee78a596944eaa38f28aff5672699d97aad779c57ddcce84bed2a14d09f5c0a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee78a596944eaa38f28aff5672699d97aad779c57ddcce84bed2a14d09f5c0a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee78a596944eaa38f28aff5672699d97aad779c57ddcce84bed2a14d09f5c0a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "564f446e42fbcdb519e70f1633933f240910e0053a4d6891f3a7e1f6c0153442"
    sha256 cellar: :any_skip_relocation, ventura:       "564f446e42fbcdb519e70f1633933f240910e0053a4d6891f3a7e1f6c0153442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ee5fbb46158e41b5a24d6098962e726ba175faac28bb74a3472defb3f0c424"
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