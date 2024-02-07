require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.27.0.tgz"
  sha256 "fffca6c1e85ee0e189794158fe21a51966b3b832fa0f23f800c58d3b4e5cfe45"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89c71529518a2b3a4461d53aebebc24262d1732f4263f09ba8f31da73737dbb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c71529518a2b3a4461d53aebebc24262d1732f4263f09ba8f31da73737dbb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c71529518a2b3a4461d53aebebc24262d1732f4263f09ba8f31da73737dbb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd9f18d344a1e0ed2f8db926348fe46bdcdd568ff83fcd806d533a261f2f0e7d"
    sha256 cellar: :any_skip_relocation, ventura:        "dd9f18d344a1e0ed2f8db926348fe46bdcdd568ff83fcd806d533a261f2f0e7d"
    sha256 cellar: :any_skip_relocation, monterey:       "dd9f18d344a1e0ed2f8db926348fe46bdcdd568ff83fcd806d533a261f2f0e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3b2db13b5a099cf96eab4993b86e4675234db74bf55528a1fdc8fa69f4699f7"
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