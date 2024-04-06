require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.48.0.tgz"
  sha256 "1df3643bba3c451ab92f46592d529efee6ea22a19984d812578c71ca6a39c9bf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6ebaa2435130de509bdb9eaebec07802438f98ebd761fc64ca2e97a2119f5a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6ebaa2435130de509bdb9eaebec07802438f98ebd761fc64ca2e97a2119f5a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ebaa2435130de509bdb9eaebec07802438f98ebd761fc64ca2e97a2119f5a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e63b3120c7b798adf3210231ab8d976a6797a4403a55105d58f75a23cc6f9d1"
    sha256 cellar: :any_skip_relocation, ventura:        "4e63b3120c7b798adf3210231ab8d976a6797a4403a55105d58f75a23cc6f9d1"
    sha256 cellar: :any_skip_relocation, monterey:       "4e63b3120c7b798adf3210231ab8d976a6797a4403a55105d58f75a23cc6f9d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61c24a4e2bc07979f1c5fd7e6f2646034f1ebf6bf02e1c11d4342d96617fc27"
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