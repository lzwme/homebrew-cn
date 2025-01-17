class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.103.1.tgz"
  sha256 "2bcc83748516f71aa86489282993de688f026fa160f52c44d4e9112e458a61a6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c22f3a85615f07487b6c60f1855bd2040daf392c3775b25357a67c4910fa5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1c22f3a85615f07487b6c60f1855bd2040daf392c3775b25357a67c4910fa5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1c22f3a85615f07487b6c60f1855bd2040daf392c3775b25357a67c4910fa5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "35c66c1418fecb7b9857ad8b698936d60ce17159fb0f20f4896affddcbd1b06f"
    sha256 cellar: :any_skip_relocation, ventura:       "35c66c1418fecb7b9857ad8b698936d60ce17159fb0f20f4896affddcbd1b06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a5d26fdbbaf7d5cb4b15745f3dde30e385122f3f69709ed020ea267c4895d4e"
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