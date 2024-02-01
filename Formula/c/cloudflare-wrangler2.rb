require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.26.0.tgz"
  sha256 "ebedd12a7b40fd5e2bc25ac97b89d9477d68dacfec3edb79637d25bcfa45bd12"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0d53544fc6d0365230fff0afd2a7e19e4413345b2e4f2625fda67e75a509f1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0d53544fc6d0365230fff0afd2a7e19e4413345b2e4f2625fda67e75a509f1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d53544fc6d0365230fff0afd2a7e19e4413345b2e4f2625fda67e75a509f1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e94371c4fb96a7f81e232f43d3cb5a0659c47b3012ee0a1279cd2115e6958f5"
    sha256 cellar: :any_skip_relocation, ventura:        "3e94371c4fb96a7f81e232f43d3cb5a0659c47b3012ee0a1279cd2115e6958f5"
    sha256 cellar: :any_skip_relocation, monterey:       "3e94371c4fb96a7f81e232f43d3cb5a0659c47b3012ee0a1279cd2115e6958f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51b6590bd70b8fab41b88fd4df1fe068b134dcf50f73b5546ae2e3a797dc4b7"
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