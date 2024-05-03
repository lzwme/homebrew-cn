require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.53.1.tgz"
  sha256 "6e0999f517103f557f18ce1c768134542d2ae3f313b86f9c72e8e4f5e1bf30c1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "202da30267fb521b0a9360bc5614bb115708edc5a8279d26d2e67c726742efbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "202da30267fb521b0a9360bc5614bb115708edc5a8279d26d2e67c726742efbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "202da30267fb521b0a9360bc5614bb115708edc5a8279d26d2e67c726742efbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3531609b532a041d6e9d71f0ba9fa70985804781dfc3e3e2663e20a7e4823e50"
    sha256 cellar: :any_skip_relocation, ventura:        "3531609b532a041d6e9d71f0ba9fa70985804781dfc3e3e2663e20a7e4823e50"
    sha256 cellar: :any_skip_relocation, monterey:       "3531609b532a041d6e9d71f0ba9fa70985804781dfc3e3e2663e20a7e4823e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fe104e1ec5d9162c3661826a005bc3a730feb8d7c703e441e3791d8d2fd7207"
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