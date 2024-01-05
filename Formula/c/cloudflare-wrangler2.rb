require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.22.3.tgz"
  sha256 "c21444ca11bf864886942572217fb158775460c29a1c949431942839990c8b4e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a25957694b8cf95b506562add387da6f631d5626a56e775da7c7461ffdc499ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a25957694b8cf95b506562add387da6f631d5626a56e775da7c7461ffdc499ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a25957694b8cf95b506562add387da6f631d5626a56e775da7c7461ffdc499ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d219cd2f5765c47f7242573a8a22af814775e07562237489c40322640fa536e"
    sha256 cellar: :any_skip_relocation, ventura:        "1d219cd2f5765c47f7242573a8a22af814775e07562237489c40322640fa536e"
    sha256 cellar: :any_skip_relocation, monterey:       "1d219cd2f5765c47f7242573a8a22af814775e07562237489c40322640fa536e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "446baf0ec3ddea549fef13a2531ec209b1cec2ad9ec5194adbcbb411089b9bf0"
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