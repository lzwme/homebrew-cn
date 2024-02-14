require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.28.2.tgz"
  sha256 "17285f115de71fda0b311716436fb6325ada6bd2920686e99d9d708f82b700d2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "550941ede78be4d9f109204be83d2c19b80275423c39d4e21d6663f688fb6550"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "550941ede78be4d9f109204be83d2c19b80275423c39d4e21d6663f688fb6550"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "550941ede78be4d9f109204be83d2c19b80275423c39d4e21d6663f688fb6550"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb70e19d592ec57a20c7dc3bf62ba561bfaae2917a7ce660999ff20dbf20b8f5"
    sha256 cellar: :any_skip_relocation, ventura:        "eb70e19d592ec57a20c7dc3bf62ba561bfaae2917a7ce660999ff20dbf20b8f5"
    sha256 cellar: :any_skip_relocation, monterey:       "eb70e19d592ec57a20c7dc3bf62ba561bfaae2917a7ce660999ff20dbf20b8f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7d6206d24bccef3304ff7f70a1e6e07c0f3e67fe321af4633321dc9f0adebfb"
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