require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.63.1.tgz"
  sha256 "33972c4114b416d270bbc93b7ed685b801df9c494a5e966425977d700605aec3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efe8f6031b732dd4144256d0186e4c836a101c7619fa997812bcb3fe05435228"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe8f6031b732dd4144256d0186e4c836a101c7619fa997812bcb3fe05435228"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efe8f6031b732dd4144256d0186e4c836a101c7619fa997812bcb3fe05435228"
    sha256 cellar: :any_skip_relocation, sonoma:         "54b24e2514a1e46afaf84b32deed3c179cdc8be9785979b2416b9032b50769ae"
    sha256 cellar: :any_skip_relocation, ventura:        "54b24e2514a1e46afaf84b32deed3c179cdc8be9785979b2416b9032b50769ae"
    sha256 cellar: :any_skip_relocation, monterey:       "54b24e2514a1e46afaf84b32deed3c179cdc8be9785979b2416b9032b50769ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "313ea5d22c9bed83ffaf5ac5fce63505f7557f33013c6d9f2f5632ea8286830a"
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