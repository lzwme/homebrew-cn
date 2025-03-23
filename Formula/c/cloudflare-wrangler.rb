class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.4.0.tgz"
  sha256 "82796f2da42d8a902caa5c9254ab2df86ad54600fb2052cbb930635a25f2a786"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "789294e9c02857266aeac0a9a07ca80b3b775c9b018eed18c33f1f844532e212"
    sha256 cellar: :any,                 arm64_sonoma:  "789294e9c02857266aeac0a9a07ca80b3b775c9b018eed18c33f1f844532e212"
    sha256 cellar: :any,                 arm64_ventura: "789294e9c02857266aeac0a9a07ca80b3b775c9b018eed18c33f1f844532e212"
    sha256                               sonoma:        "5a66239ab5667bed761c05aba7bdfcc7f5a486e625ec2d6369b0fad14000c2d1"
    sha256                               ventura:       "5a66239ab5667bed761c05aba7bdfcc7f5a486e625ec2d6369b0fad14000c2d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a82dc4d6bdac28003678ea05ff70b3d4d3b0849e72f5fa3f5bf86c6dff824ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91c7cd92dc5ee7d0ea93bb3fa0b37384a373391ad32f22eed3d5186507a5a9ad"
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