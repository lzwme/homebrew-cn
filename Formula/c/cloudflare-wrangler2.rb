require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.51.2.tgz"
  sha256 "cb2db58b73368aec7e5ecc023689b42064432f3631fa82df1305b53ce2d63af2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aacf00c91ff8df64be3246779c7b2d3fb1ced5a6b21355b20913fa4c6189a6c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aacf00c91ff8df64be3246779c7b2d3fb1ced5a6b21355b20913fa4c6189a6c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aacf00c91ff8df64be3246779c7b2d3fb1ced5a6b21355b20913fa4c6189a6c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "80339935af0ddaadf670506b240b382bd17c4e7cd195722b2bb97a54c2c3520a"
    sha256 cellar: :any_skip_relocation, ventura:        "80339935af0ddaadf670506b240b382bd17c4e7cd195722b2bb97a54c2c3520a"
    sha256 cellar: :any_skip_relocation, monterey:       "80339935af0ddaadf670506b240b382bd17c4e7cd195722b2bb97a54c2c3520a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1197f874d78c2e4377b54d61a1658ac0b8775c8b0308226caf8302254ed827a1"
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