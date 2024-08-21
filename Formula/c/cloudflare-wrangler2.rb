class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.72.1.tgz"
  sha256 "3df7e1bb2643c19fb53ed728cc1e64a10b63ca47321a148a414d41e7324e0cc6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4e107e16db7622b96943b6c0f431aad7cb40e94b6a47e400e4f8a792a93ec47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4e107e16db7622b96943b6c0f431aad7cb40e94b6a47e400e4f8a792a93ec47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4e107e16db7622b96943b6c0f431aad7cb40e94b6a47e400e4f8a792a93ec47"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf370de309f5a1c966e14f61231082cfcf7316f083d44d1d8b1eecb4d9e5a109"
    sha256 cellar: :any_skip_relocation, ventura:        "cf370de309f5a1c966e14f61231082cfcf7316f083d44d1d8b1eecb4d9e5a109"
    sha256 cellar: :any_skip_relocation, monterey:       "cf370de309f5a1c966e14f61231082cfcf7316f083d44d1d8b1eecb4d9e5a109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff7a7b43258e245e1f9c7b3cf382f8279d67154b2a64001ca9caa68e637107af"
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