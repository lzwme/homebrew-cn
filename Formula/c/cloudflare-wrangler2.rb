require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.37.0.tgz"
  sha256 "b499a6f1de3a27698a82c88e41709ecfedb1178d085129db2c7b50562678af56"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dcbb465c7453566d003e10e299c40f8b4740f87fd030f685b2380c61054f2cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dcbb465c7453566d003e10e299c40f8b4740f87fd030f685b2380c61054f2cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dcbb465c7453566d003e10e299c40f8b4740f87fd030f685b2380c61054f2cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "71829abb65410cd96689d4fc07cd5309cfc1f0d0639f7a92aecf4f6435c95077"
    sha256 cellar: :any_skip_relocation, ventura:        "71829abb65410cd96689d4fc07cd5309cfc1f0d0639f7a92aecf4f6435c95077"
    sha256 cellar: :any_skip_relocation, monterey:       "71829abb65410cd96689d4fc07cd5309cfc1f0d0639f7a92aecf4f6435c95077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7348481e6f1f7e0c0b85e15b76f53dff602ebdcd109313142f97c0ec650f9da3"
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