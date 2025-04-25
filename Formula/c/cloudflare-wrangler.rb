class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.13.1.tgz"
  sha256 "cb3ed8a860ccbee2e8a7568e63f64224198928c690fe8d80c5b5de723cff2d20"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4195c11bbb77d36548f958ab61926673202cb9e98b20cb634d3b04493e2bc44f"
    sha256 cellar: :any,                 arm64_sonoma:  "4195c11bbb77d36548f958ab61926673202cb9e98b20cb634d3b04493e2bc44f"
    sha256 cellar: :any,                 arm64_ventura: "4195c11bbb77d36548f958ab61926673202cb9e98b20cb634d3b04493e2bc44f"
    sha256                               sonoma:        "7d7326abb0850e5b52410dd13e772b3510deff9a0c1561c69674dcd5cc4a16ad"
    sha256                               ventura:       "7d7326abb0850e5b52410dd13e772b3510deff9a0c1561c69674dcd5cc4a16ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c51d0a131580624f9df46f94e636e31169d2de412aba2cefa9eb809f2f0a96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5069dec6275205567a4f388add439503ab9620e92bf834aaa30c3f8c3db8f1c6"
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