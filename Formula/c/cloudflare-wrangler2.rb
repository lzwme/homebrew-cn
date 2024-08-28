class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.72.3.tgz"
  sha256 "187c8f37bb5c9fe3ec7830a4419f50e99fb9422092348c94ade3944944473109"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f55d206ea1ec8390f862a699fae1f75882c5ff2a562f485a67a3cea728cd20ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f55d206ea1ec8390f862a699fae1f75882c5ff2a562f485a67a3cea728cd20ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f55d206ea1ec8390f862a699fae1f75882c5ff2a562f485a67a3cea728cd20ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "695ffe9c5940dc1a9cf35d4a4e7dc67b0bb7aa561ab4e66848b71b0b0b9d0a14"
    sha256 cellar: :any_skip_relocation, ventura:        "695ffe9c5940dc1a9cf35d4a4e7dc67b0bb7aa561ab4e66848b71b0b0b9d0a14"
    sha256 cellar: :any_skip_relocation, monterey:       "695ffe9c5940dc1a9cf35d4a4e7dc67b0bb7aa561ab4e66848b71b0b0b9d0a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "559bbb0f08bc3b09d87a2d6de395752795eb9be6eae027e7dbfec29dd5c4557b"
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