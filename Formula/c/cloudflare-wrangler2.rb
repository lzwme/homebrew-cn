class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.102.0.tgz"
  sha256 "20fca073f425cc9e5530cc85bf764c95ae1b321c841d116c8ac33287fdbae3b4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec3bb54cfb3d42b7e59a0610deacc28e24828ce3fa6d208aa585e2548a5bed67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec3bb54cfb3d42b7e59a0610deacc28e24828ce3fa6d208aa585e2548a5bed67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec3bb54cfb3d42b7e59a0610deacc28e24828ce3fa6d208aa585e2548a5bed67"
    sha256 cellar: :any_skip_relocation, sonoma:        "9941683cc0552c84459bc71c8cf463df5c2480d7a471822da0d77f5a19117f62"
    sha256 cellar: :any_skip_relocation, ventura:       "9941683cc0552c84459bc71c8cf463df5c2480d7a471822da0d77f5a19117f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b76371b3ada5c3d113e2ba471d1b9f8bb3ba9ccc1764cf0db88ebf22957479c"
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