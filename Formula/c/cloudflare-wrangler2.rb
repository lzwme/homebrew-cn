class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.89.0.tgz"
  sha256 "e848db717f2c9b6642aab2e230efb957b4c7ca4437d5db2fb638317fecd22ea1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25100a0d9942fb26b02e5d5a5e059b1af40cc6d42928912dfb80697dcf4d81c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25100a0d9942fb26b02e5d5a5e059b1af40cc6d42928912dfb80697dcf4d81c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d25100a0d9942fb26b02e5d5a5e059b1af40cc6d42928912dfb80697dcf4d81c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8244cb59053a6a02914e14381d5d221811c0db96d92563c98f35b17e9475668"
    sha256 cellar: :any_skip_relocation, ventura:       "b8244cb59053a6a02914e14381d5d221811c0db96d92563c98f35b17e9475668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a38b49a9d1d77ca43f8dbf1b58edf28ea4e33baccfb791f66187c377b657e48"
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