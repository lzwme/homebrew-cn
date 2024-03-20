require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.35.0.tgz"
  sha256 "c075b8b4e4f15795c386fc04eb90b314852c0640b32678dba2353df535f469d7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "245b76b9390d53c28c46ab1e886e5ec4bec32b2a3cc20c6397238d2879345f28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "245b76b9390d53c28c46ab1e886e5ec4bec32b2a3cc20c6397238d2879345f28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "245b76b9390d53c28c46ab1e886e5ec4bec32b2a3cc20c6397238d2879345f28"
    sha256 cellar: :any_skip_relocation, sonoma:         "28f32b2accd744cf1b850506042bd96b332988fc944325ac799e6e382c426796"
    sha256 cellar: :any_skip_relocation, ventura:        "28f32b2accd744cf1b850506042bd96b332988fc944325ac799e6e382c426796"
    sha256 cellar: :any_skip_relocation, monterey:       "28f32b2accd744cf1b850506042bd96b332988fc944325ac799e6e382c426796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36ce2425e005c46d2b67b90bcca73bbf802086cd97705db2d689b776c4429833"
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