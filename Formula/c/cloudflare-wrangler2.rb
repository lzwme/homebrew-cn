require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.30.0.tgz"
  sha256 "4bd4658e313c6caa443f856cb4aa66119a4d178b04680051adf201faeb070289"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31cc02c6eb15d8c3523241d74fa8944d2c1bf8d2981ee9586d76c34804596c83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31cc02c6eb15d8c3523241d74fa8944d2c1bf8d2981ee9586d76c34804596c83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31cc02c6eb15d8c3523241d74fa8944d2c1bf8d2981ee9586d76c34804596c83"
    sha256 cellar: :any_skip_relocation, sonoma:         "c713257b33b65d533b9801141297861644eb3a72e7092bb2d1f5a1830b13cd6e"
    sha256 cellar: :any_skip_relocation, ventura:        "c713257b33b65d533b9801141297861644eb3a72e7092bb2d1f5a1830b13cd6e"
    sha256 cellar: :any_skip_relocation, monterey:       "c713257b33b65d533b9801141297861644eb3a72e7092bb2d1f5a1830b13cd6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c848fcd8d60dacc67ba6b2f43865a003eb88ff47a384938b39be4fb4006a5cff"
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