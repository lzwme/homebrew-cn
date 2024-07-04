require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.63.0.tgz"
  sha256 "38e7d99725677889e21cab70502c7759578eb00af90c8b334615ba5c89b7475a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "467020d11aa0c5efa5c9cdf68cfa2ac220302382d7e735a9ef01cbf255d48a40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "467020d11aa0c5efa5c9cdf68cfa2ac220302382d7e735a9ef01cbf255d48a40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "467020d11aa0c5efa5c9cdf68cfa2ac220302382d7e735a9ef01cbf255d48a40"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfbe7b4e4e806948d3923146d3c7ce40f96dc1b44ffc81a102d3e6d653c462b1"
    sha256 cellar: :any_skip_relocation, ventura:        "dfbe7b4e4e806948d3923146d3c7ce40f96dc1b44ffc81a102d3e6d653c462b1"
    sha256 cellar: :any_skip_relocation, monterey:       "dfbe7b4e4e806948d3923146d3c7ce40f96dc1b44ffc81a102d3e6d653c462b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15c7d134344f76e92cf6e637cddbc9cc93d056d07d2be6ecba98993cf76ce51a"
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