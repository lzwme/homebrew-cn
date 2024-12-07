class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.93.0.tgz"
  sha256 "2148dab0589a4ffab8b1814b8445be12c0c60de54dd39c24f83426ecbddc2ab8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50f3d2a16a44f53c6db86b9679608ea606628aeb786a1837ec99430caf2194a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50f3d2a16a44f53c6db86b9679608ea606628aeb786a1837ec99430caf2194a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50f3d2a16a44f53c6db86b9679608ea606628aeb786a1837ec99430caf2194a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c4dfc8fae90d5bba6e29b8d27040b2c098a6b26dbd61a4234c355d2f9cb9c20"
    sha256 cellar: :any_skip_relocation, ventura:       "5c4dfc8fae90d5bba6e29b8d27040b2c098a6b26dbd61a4234c355d2f9cb9c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b84a69e5bdc74baf8bc9a2116f36a27a2e7dcf5a6fb31235f99ae3d9b24e5a23"
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