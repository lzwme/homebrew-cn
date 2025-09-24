class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.39.0.tgz"
  sha256 "717a3569b6be5c16960da888c629df2eebcd5e7f33e9ef502ea9ee053cbff69a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ea6375bfa4bc75e58dfe06d10a3b08307fbb0656260dece60b6d1579bc974ff"
    sha256 cellar: :any,                 arm64_sequoia: "a42a79cf880321dfbe832e2e75222b7473855231a91f2dd8e22ba2ba1933d70a"
    sha256 cellar: :any,                 arm64_sonoma:  "a42a79cf880321dfbe832e2e75222b7473855231a91f2dd8e22ba2ba1933d70a"
    sha256 cellar: :any,                 sonoma:        "b65dfe425f16d6cb1fcaca57103dc02195a2b6a1972b65d15a5405cbf39c2a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc9cd72ab2f5a15897f7cebef816acc07ab5884ca092ac4f54ba2997f69d400d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9dded3b2748c3528b8dc63fad97e6fa15fda7c3fe03d5bb2e238edb2bc59a92"
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