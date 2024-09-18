class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.78.4.tgz"
  sha256 "969f75ac0a3408172378faa769d7753a1692ce812f9f93ba6d9db27377778725"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4900dc540a52e2cb131829325feaa0bde45511e34f3e766bc306a4c2e3d2b5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4900dc540a52e2cb131829325feaa0bde45511e34f3e766bc306a4c2e3d2b5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4900dc540a52e2cb131829325feaa0bde45511e34f3e766bc306a4c2e3d2b5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6e0aebcb7238be261edd1e9c4ba0d0836af919b59924d64bf7bb5c0505f9786"
    sha256 cellar: :any_skip_relocation, ventura:       "a6e0aebcb7238be261edd1e9c4ba0d0836af919b59924d64bf7bb5c0505f9786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0311d2f41dd4aefe4f5294d13f59dbe2cf9cbe1f9e40b7464837dd8a3d628c00"
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