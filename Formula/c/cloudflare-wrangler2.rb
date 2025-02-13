class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.108.1.tgz"
  sha256 "45371f41a797be97397de3ec3eeb679f90b64c224bc115c8752ca648e2e25727"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "67944b5273deead72fba0152e68658c804f6757df170a04a5017d1f01df64cde"
    sha256 cellar: :any,                 arm64_sonoma:  "67944b5273deead72fba0152e68658c804f6757df170a04a5017d1f01df64cde"
    sha256 cellar: :any,                 arm64_ventura: "67944b5273deead72fba0152e68658c804f6757df170a04a5017d1f01df64cde"
    sha256                               sonoma:        "fa14e6e3ed190ba5ffdda5e9ca1c28bcff23440c0700231d68a1c4fef1660c60"
    sha256                               ventura:       "fa14e6e3ed190ba5ffdda5e9ca1c28bcff23440c0700231d68a1c4fef1660c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db9c96e11a8a56266729944e70e793ad36e27c8ba8c34ecaca3bb488466f4757"
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