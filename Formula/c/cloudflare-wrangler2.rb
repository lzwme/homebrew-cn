require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.63.2.tgz"
  sha256 "61384f55468c830692427b057b13bd532eabdbf972fd3af35cdb2ca4cb6c49bd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb644f06834384fcfb3712b8eb812e4f313151c3ca765d197fa962205d1a3a69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb644f06834384fcfb3712b8eb812e4f313151c3ca765d197fa962205d1a3a69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb644f06834384fcfb3712b8eb812e4f313151c3ca765d197fa962205d1a3a69"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebba167d51a92198a44c84ae62b46a889849b8bbe9806dc25c8473debb83fb83"
    sha256 cellar: :any_skip_relocation, ventura:        "33ac8f61b5284ad9e158422e913dd4b9cd01db55a25c29cd5a9f1163ae83a188"
    sha256 cellar: :any_skip_relocation, monterey:       "ebba167d51a92198a44c84ae62b46a889849b8bbe9806dc25c8473debb83fb83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8153e5044452c7a7cf17088164f2d23d093360aa9ee64029d153d4ab50779889"
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