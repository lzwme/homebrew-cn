require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.65.1.tgz"
  sha256 "61e6125543d9b50b7241c5ac582fe03d5c1cf1ab60e75b2bf861a713c4434079"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25c776c4d0130c42323cb83e1fcbbcfe0a31fe9cff02a2c8b6cd51478ae39623"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25c776c4d0130c42323cb83e1fcbbcfe0a31fe9cff02a2c8b6cd51478ae39623"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c776c4d0130c42323cb83e1fcbbcfe0a31fe9cff02a2c8b6cd51478ae39623"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e9be94ea04b80187bab33973ea61a000fb946d4f1d1178ecd91049c5d711993"
    sha256 cellar: :any_skip_relocation, ventura:        "7e9be94ea04b80187bab33973ea61a000fb946d4f1d1178ecd91049c5d711993"
    sha256 cellar: :any_skip_relocation, monterey:       "7e9be94ea04b80187bab33973ea61a000fb946d4f1d1178ecd91049c5d711993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9826e91faa0299ff41354c47f96fa3e2b9f962ad4254606dbc0b765f6a226890"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}libnode_modules***"]
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end