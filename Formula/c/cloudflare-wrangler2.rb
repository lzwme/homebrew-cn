require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.58.0.tgz"
  sha256 "b997e0e0114667098d8b1bc53df8334ce94a90601db6c90bebf6b3a92654e32f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31d0925a6698ed9dcd6e35d1ba63df9b236d9767cfdfe93bacd40fcf7beffc3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31d0925a6698ed9dcd6e35d1ba63df9b236d9767cfdfe93bacd40fcf7beffc3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31d0925a6698ed9dcd6e35d1ba63df9b236d9767cfdfe93bacd40fcf7beffc3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "90ed043dc03960fac9e716dc8690dcc6f371498c08b83b52695c30a8e0e7b1c5"
    sha256 cellar: :any_skip_relocation, ventura:        "4eb4a86aa19e9720fc117745b239310536d851c1de4f7ac3abcc592c3ee70b8f"
    sha256 cellar: :any_skip_relocation, monterey:       "90ed043dc03960fac9e716dc8690dcc6f371498c08b83b52695c30a8e0e7b1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4865cd95c410c86217340dd4195bf12676e20e4ab9b5a50fd91dad22156fd7b1"
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