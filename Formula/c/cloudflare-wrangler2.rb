require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.22.5.tgz"
  sha256 "c3f5bc4630ed2e2430d42946c0500a9a3e648fe48ae487b9f9e40989d8aa5e46"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08000d4e7f5e5142b752a22d6aaef93a30d13be5bf85ffc253171b8150ca4d05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08000d4e7f5e5142b752a22d6aaef93a30d13be5bf85ffc253171b8150ca4d05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08000d4e7f5e5142b752a22d6aaef93a30d13be5bf85ffc253171b8150ca4d05"
    sha256 cellar: :any_skip_relocation, sonoma:         "874ff6c5f9a0ab157616633fb577df2337b50ac82a0fcf3494a4e8c0e0c43e00"
    sha256 cellar: :any_skip_relocation, ventura:        "874ff6c5f9a0ab157616633fb577df2337b50ac82a0fcf3494a4e8c0e0c43e00"
    sha256 cellar: :any_skip_relocation, monterey:       "874ff6c5f9a0ab157616633fb577df2337b50ac82a0fcf3494a4e8c0e0c43e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "082f5b451a1fb99124149f18a96b29086f1f02022c7333b1de21e0dcb8ca26db"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}libnode_modules***"]
    bin.install_symlink Dir["#{libexec}binwrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec"libnode_moduleswranglernode_modulesfseventsfsevents.node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end