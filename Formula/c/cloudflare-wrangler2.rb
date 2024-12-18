class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.97.0.tgz"
  sha256 "23dc9cc0a1e07d07bacf34c4dac5e95df8d99697c435b7b80b7c314de87db20f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "428b5d9f34c20dc2b53d8db8069a22b5b720d5601893b414efa826cda9a9b4c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "428b5d9f34c20dc2b53d8db8069a22b5b720d5601893b414efa826cda9a9b4c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "428b5d9f34c20dc2b53d8db8069a22b5b720d5601893b414efa826cda9a9b4c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f5853e4c798f6fb62f3e90cfc3185570d31046f8aa2f42c474a05195b07e6e9"
    sha256 cellar: :any_skip_relocation, ventura:       "5f5853e4c798f6fb62f3e90cfc3185570d31046f8aa2f42c474a05195b07e6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6e096064abc3dc9f2fad68c448b7ae67fa4fcd75439dbe33eece3d1e7886ddb"
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