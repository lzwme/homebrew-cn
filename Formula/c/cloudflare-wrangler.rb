class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.40.2.tgz"
  sha256 "cbe87e0a987ae647cbe45e2f5dbdce83f18f80e45f322807f16f077f009f3a03"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba58bd72a7713b0d7bb3f1fdffb2f5825f9b14c093cf9b7ecb22094db7720483"
    sha256 cellar: :any,                 arm64_sequoia: "b452450fdabace6aee7331221234f0cc6e0c6a846bef45b195dc67fc674ecb55"
    sha256 cellar: :any,                 arm64_sonoma:  "b452450fdabace6aee7331221234f0cc6e0c6a846bef45b195dc67fc674ecb55"
    sha256 cellar: :any,                 sonoma:        "5dd0468c551c1f01ab8bcb594e85e1daa222aa63950f97cab5c0fc374def86e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1aec8a6b5711e79a685041a4918fd35099dce0759aecc42a7aff47fb5cc2e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8355ee849cc6b2a602c3f19965a0ef616bd0dc66ae6989cc40738d618a87620"
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