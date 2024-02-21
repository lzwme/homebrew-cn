require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.28.4.tgz"
  sha256 "379c769ad98d9d06ad91ab1e0c7818d2d81c7d62fc6494d0a0a094d2002a4ada"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b92133e7d35913681d957e412b2bf857750e7bd7caa6e2d47f301955549132ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b92133e7d35913681d957e412b2bf857750e7bd7caa6e2d47f301955549132ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b92133e7d35913681d957e412b2bf857750e7bd7caa6e2d47f301955549132ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "f93c1ed10eac8cb91daf26e2d72caf2dda7efedc244df2f79ea5b3867cb5124b"
    sha256 cellar: :any_skip_relocation, ventura:        "f93c1ed10eac8cb91daf26e2d72caf2dda7efedc244df2f79ea5b3867cb5124b"
    sha256 cellar: :any_skip_relocation, monterey:       "f93c1ed10eac8cb91daf26e2d72caf2dda7efedc244df2f79ea5b3867cb5124b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69366ad356ddd2aee2a7829d55b6c6867364d5dac5b551150ad1a058016970fb"
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