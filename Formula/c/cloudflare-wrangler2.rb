class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.78.6.tgz"
  sha256 "b63a022173f423f54a340dc636bbfc36b82520eb7b109ce5f99e756d7777c0d5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc97c8002f2ad46b404fc2b3b44135affe075c1cd4eb44299e2e0a205235e1fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc97c8002f2ad46b404fc2b3b44135affe075c1cd4eb44299e2e0a205235e1fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc97c8002f2ad46b404fc2b3b44135affe075c1cd4eb44299e2e0a205235e1fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f12e481a7ce54d1a6da22db58b6033a99b3f77718e987bdf198a850de3852c0"
    sha256 cellar: :any_skip_relocation, ventura:       "9f12e481a7ce54d1a6da22db58b6033a99b3f77718e987bdf198a850de3852c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfcb6b40c10d5f29a969ff1e0592a1e5f93a9ff613ffc3c1d6c0ac2fd090890a"
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