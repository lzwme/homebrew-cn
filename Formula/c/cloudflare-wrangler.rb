class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.35.0.tgz"
  sha256 "ecc90a91a37282aaa8b4337ed2a16f962c7c204f8b0e29a355f87a5abd21af72"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "67484c1ab97495fe7e0d8ff85d3a4f01896ff39f6f03db91b633c8e4c65d4295"
    sha256 cellar: :any,                 arm64_sonoma:  "67484c1ab97495fe7e0d8ff85d3a4f01896ff39f6f03db91b633c8e4c65d4295"
    sha256 cellar: :any,                 arm64_ventura: "67484c1ab97495fe7e0d8ff85d3a4f01896ff39f6f03db91b633c8e4c65d4295"
    sha256 cellar: :any,                 sonoma:        "02a44b5a646598e7d49432a9277ee3e4e2108ccf601c56b13445b134329a1e1f"
    sha256 cellar: :any,                 ventura:       "02a44b5a646598e7d49432a9277ee3e4e2108ccf601c56b13445b134329a1e1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59e9ae70d5ffe71ac29cdca65348deae31c9ea0b31e053e38065f4155708a054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b6245d5545459fc6f5391f23d232d3b149cb72c3c8bdbf580b079518dd864dc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end