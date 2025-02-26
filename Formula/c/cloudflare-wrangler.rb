class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.110.0.tgz"
  sha256 "47708547de659aeaa3dbd83f98134a20f61e6271167524d2644f37af96e35d1d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ede71c438d0ca250211218a077ea0d3eb9d4919c1054cd52ebe7de3ce6241833"
    sha256 cellar: :any,                 arm64_sonoma:  "ede71c438d0ca250211218a077ea0d3eb9d4919c1054cd52ebe7de3ce6241833"
    sha256 cellar: :any,                 arm64_ventura: "ede71c438d0ca250211218a077ea0d3eb9d4919c1054cd52ebe7de3ce6241833"
    sha256                               sonoma:        "f82d5e4f6750c89a10002cf29d50a1b28eb9f638768ff7f13597cec5434b4965"
    sha256                               ventura:       "f82d5e4f6750c89a10002cf29d50a1b28eb9f638768ff7f13597cec5434b4965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c061d7f4bbe0ac07b4f15dc9a1ea8dba55b8ae3c6f57cfeb03e13a9ad277752c"
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