class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.90.0.tgz"
  sha256 "5b7f2cca61110e75c111d0fea18f2b6295f7996f9f66edf17051f00bb48a0101"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62fa371bc527b3c7795e275bdfe6c552ccc573d2cf8a54b3921556a67904286a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62fa371bc527b3c7795e275bdfe6c552ccc573d2cf8a54b3921556a67904286a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62fa371bc527b3c7795e275bdfe6c552ccc573d2cf8a54b3921556a67904286a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6a9fbbc9fced659c9b5be9f92889fff052393a9032a05d7f8c53a4935137917"
    sha256 cellar: :any_skip_relocation, ventura:       "c6a9fbbc9fced659c9b5be9f92889fff052393a9032a05d7f8c53a4935137917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cba537977ec07313ad35ad020e04d27e45d30c8bccb33af4fabec62c0444729a"
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