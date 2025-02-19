class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.109.2.tgz"
  sha256 "46933854f9964f912e34b1023556ab8eebcc360cd178e9c92d57e0fb3627a4c1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "626fd2938923bb5959120ba7991c29df14631f92a8fc6f3dc10be173a839be41"
    sha256 cellar: :any,                 arm64_sonoma:  "626fd2938923bb5959120ba7991c29df14631f92a8fc6f3dc10be173a839be41"
    sha256 cellar: :any,                 arm64_ventura: "626fd2938923bb5959120ba7991c29df14631f92a8fc6f3dc10be173a839be41"
    sha256                               sonoma:        "adab7ece901bd9f0981edc1fdd2a003fb587448426eae91ba6a0da27ac539816"
    sha256                               ventura:       "adab7ece901bd9f0981edc1fdd2a003fb587448426eae91ba6a0da27ac539816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f0946e247266243f02959fbe11bad7ee8a89b1a1622e15f0461f3a1ac9ab192"
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