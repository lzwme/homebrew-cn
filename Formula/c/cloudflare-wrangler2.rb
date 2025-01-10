class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.101.0.tgz"
  sha256 "b22f7ba1f033f873285adc275f06637d152233a046111d9244aab9c27666fd8b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab63e889319262301fe3b5ed1e20e6760872ea41d503416ef8ce56a8008c50b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab63e889319262301fe3b5ed1e20e6760872ea41d503416ef8ce56a8008c50b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab63e889319262301fe3b5ed1e20e6760872ea41d503416ef8ce56a8008c50b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e395c1f7f56a0a10b3ee6118b6569a82688f27247f43ffe8c32e99f12e7a6d18"
    sha256 cellar: :any_skip_relocation, ventura:       "e395c1f7f56a0a10b3ee6118b6569a82688f27247f43ffe8c32e99f12e7a6d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f3b8eb890aad80c8859c33a38b33881bbd9dffca740128b5846debdc2c45dd"
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