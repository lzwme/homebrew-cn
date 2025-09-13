class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.36.0.tgz"
  sha256 "1effd6122bafb6182202119b3883fdb775a557d474aa7bdaa48c5a9f360ab672"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c51c0f0e3a277c8dc2ff10bbb32c1436e2a437e2c22f451e4a3ed848b6c46040"
    sha256 cellar: :any,                 arm64_sequoia: "4fad032733c303c2dab9655876f6c79584c66e867925154a2c8304beb55bb477"
    sha256 cellar: :any,                 arm64_sonoma:  "4fad032733c303c2dab9655876f6c79584c66e867925154a2c8304beb55bb477"
    sha256 cellar: :any,                 sonoma:        "f5907a2147a10174999815c4e6d249ec8def4af00bd469f60be73e8263c96172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3494a0321cc94de33b0c5b9b165b892a517ac18481a25457411482d771dfa8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "479a6c436eb01d851a13fb412faf6a43f4cee85c570385c07ecefe66e2c63a01"
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