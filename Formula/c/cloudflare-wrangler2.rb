class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.107.2.tgz"
  sha256 "b2356c187ca0bec0d780e80a46053732df10c8cc1295d6242b4de6eb38a10fa6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77f6f67f94c9dc5ceaa12d3b87d8060d6e475ca557b7bcdbefade82961e725c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f6f67f94c9dc5ceaa12d3b87d8060d6e475ca557b7bcdbefade82961e725c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77f6f67f94c9dc5ceaa12d3b87d8060d6e475ca557b7bcdbefade82961e725c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a6eb05ad641b90579a4f292436cecef16c75d9ad7101ea0049cfd4ee2162a21"
    sha256 cellar: :any_skip_relocation, ventura:       "8a6eb05ad641b90579a4f292436cecef16c75d9ad7101ea0049cfd4ee2162a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96594d76d633fe3e151246791ce4613119dc9dc10b755f60a0704731f4be6118"
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