require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.45.0.tgz"
  sha256 "7cffffc8c65797dbe39be5da564b989630fc52f1be10414d82369ed798532128"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21de865785c6dae375e64ba77c120e5ff14670cb4bba64535b67122acd0664df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21de865785c6dae375e64ba77c120e5ff14670cb4bba64535b67122acd0664df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21de865785c6dae375e64ba77c120e5ff14670cb4bba64535b67122acd0664df"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0e6223b3925b5d1042bec414826c496b95b086193b6c718545785dc90120b97"
    sha256 cellar: :any_skip_relocation, ventura:        "c0e6223b3925b5d1042bec414826c496b95b086193b6c718545785dc90120b97"
    sha256 cellar: :any_skip_relocation, monterey:       "db9f41cc6789805b73a302fc1609fcb05766b7750165ab155693ff90a1aa2d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "302a4cf23ae8f8ce85c8af3849950fbca578092d014671b9b43b580a77af609f"
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