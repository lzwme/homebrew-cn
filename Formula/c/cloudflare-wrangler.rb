class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.5.1.tgz"
  sha256 "b55be14f4ba952ffc0072f1196910f574186a5082a7ece445def62da6018fdc3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf7e460bbe3039d20266200c8503aa2eaf6f7499d5c9a2b0100731ee0b5f44f4"
    sha256 cellar: :any,                 arm64_sonoma:  "cf7e460bbe3039d20266200c8503aa2eaf6f7499d5c9a2b0100731ee0b5f44f4"
    sha256 cellar: :any,                 arm64_ventura: "cf7e460bbe3039d20266200c8503aa2eaf6f7499d5c9a2b0100731ee0b5f44f4"
    sha256                               sonoma:        "5b3443ee0109f18b39e4a9bfb73cda59ecbcf5646d62623db0edd407281927be"
    sha256                               ventura:       "5b3443ee0109f18b39e4a9bfb73cda59ecbcf5646d62623db0edd407281927be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dcf77776d32aef392df58535e6f565de728e9c6d586e67792b79d42033540b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65b7bae114b5dff223e80925c7e85493aa2207789f6e48449fcb23a192fe82f8"
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