require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.64.0.tgz"
  sha256 "3023dc69a2d59706d3789f0ec9eb52de313c0c3836308a11414c2b91af5f68ca"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "588b82ea042fd86cb36ca1dae1bc0dd7e4c4bdf1124756ee188462de2777039c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "588b82ea042fd86cb36ca1dae1bc0dd7e4c4bdf1124756ee188462de2777039c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "588b82ea042fd86cb36ca1dae1bc0dd7e4c4bdf1124756ee188462de2777039c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d7123fc4df5f1b8a1bbbe8b7481d8df6f9fa2bbed41024737b012941acb596c"
    sha256 cellar: :any_skip_relocation, ventura:        "1d7123fc4df5f1b8a1bbbe8b7481d8df6f9fa2bbed41024737b012941acb596c"
    sha256 cellar: :any_skip_relocation, monterey:       "1d7123fc4df5f1b8a1bbbe8b7481d8df6f9fa2bbed41024737b012941acb596c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1eb59d4d83e9b5efb9b1fa4277cad51861b0a121e7d95be5181a38e61bad0d8"
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