class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.31.0.tgz"
  sha256 "0613a6501772565950cccb2607818f6c67c96c45301a3c4b619b4f65e8b35f27"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd8360c69839544c87d865ee812e8a94190d01a2cf0fcf4c6ef0d07f7e51df9c"
    sha256 cellar: :any,                 arm64_sonoma:  "fd8360c69839544c87d865ee812e8a94190d01a2cf0fcf4c6ef0d07f7e51df9c"
    sha256 cellar: :any,                 arm64_ventura: "fd8360c69839544c87d865ee812e8a94190d01a2cf0fcf4c6ef0d07f7e51df9c"
    sha256 cellar: :any,                 sonoma:        "911e560d347d8fff20b6ca26ca8100f8c8554be68b07d96fde75f1deb5abcae9"
    sha256 cellar: :any,                 ventura:       "911e560d347d8fff20b6ca26ca8100f8c8554be68b07d96fde75f1deb5abcae9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "732e4a18b05d9ef27095aaa1810102a6ded7aeeba169cb6dccd03bbc8f5f9091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee0c90bd084f4c026860e4fa25a7376310e6768a56a85d01f4fd852e011709d"
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