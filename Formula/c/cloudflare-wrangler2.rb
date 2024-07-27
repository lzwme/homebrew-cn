require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.67.1.tgz"
  sha256 "b364f0ecc91e1b9fc46db50f42b7747c58de8db209449c195a9968c036ca17c6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da5d095cde8e944071a66ff99704f8ce50474dfe6fe2f265acb15293b0c54b96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da5d095cde8e944071a66ff99704f8ce50474dfe6fe2f265acb15293b0c54b96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da5d095cde8e944071a66ff99704f8ce50474dfe6fe2f265acb15293b0c54b96"
    sha256 cellar: :any_skip_relocation, sonoma:         "d44ed3c3c24f997f6e616f878f4bf8bd0043edb3c0ff127d9f781793c15eff81"
    sha256 cellar: :any_skip_relocation, ventura:        "d44ed3c3c24f997f6e616f878f4bf8bd0043edb3c0ff127d9f781793c15eff81"
    sha256 cellar: :any_skip_relocation, monterey:       "d44ed3c3c24f997f6e616f878f4bf8bd0043edb3c0ff127d9f781793c15eff81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d978f1ad3b7c745e7f12c028264c7b331b28778c79fde43245af3c57006a34fa"
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