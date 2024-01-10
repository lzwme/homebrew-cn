require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.22.4.tgz"
  sha256 "5c9b951850aafa70ad18aa53a43c3ed7e99812a5afe11c3f839f0c4988c56ecd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f97512257ea2bf9d65aebfca733f392e515456b9c53f9e0145d9a0c7cd30a512"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f97512257ea2bf9d65aebfca733f392e515456b9c53f9e0145d9a0c7cd30a512"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f97512257ea2bf9d65aebfca733f392e515456b9c53f9e0145d9a0c7cd30a512"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ab29872cc036760eb578a0e9ffc8df6824438de741b5de43b3d9f5cf0003909"
    sha256 cellar: :any_skip_relocation, ventura:        "5ab29872cc036760eb578a0e9ffc8df6824438de741b5de43b3d9f5cf0003909"
    sha256 cellar: :any_skip_relocation, monterey:       "5ab29872cc036760eb578a0e9ffc8df6824438de741b5de43b3d9f5cf0003909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c4aaad285957ad82347d4b4d58c082e4157b44e2d72e64b3a19ec7b1f10c7c0"
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