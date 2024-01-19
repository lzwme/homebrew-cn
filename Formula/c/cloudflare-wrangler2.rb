require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.23.0.tgz"
  sha256 "1a0c9744660f41dc43457cdd1d6f32f968fc24dae249f50fbd1f70a0c348a956"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffc381f7942eb8372f8d98b52c7842b90f009b10da6f6c7ba3a1f03bc835b83c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffc381f7942eb8372f8d98b52c7842b90f009b10da6f6c7ba3a1f03bc835b83c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffc381f7942eb8372f8d98b52c7842b90f009b10da6f6c7ba3a1f03bc835b83c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1105f291073eef1bc940f291eee733233756c8bd3a373cc49e3f9f0a2de2226"
    sha256 cellar: :any_skip_relocation, ventura:        "c1105f291073eef1bc940f291eee733233756c8bd3a373cc49e3f9f0a2de2226"
    sha256 cellar: :any_skip_relocation, monterey:       "c1105f291073eef1bc940f291eee733233756c8bd3a373cc49e3f9f0a2de2226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "483f07bef6eca5ba695a15409cc1b1d0ae695ebe1375e11fd5f554c20262dd70"
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