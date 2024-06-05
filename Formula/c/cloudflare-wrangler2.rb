require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.59.0.tgz"
  sha256 "641299cf1d31ae5f469e5c8cff6a0bb56c3ae5ab2c2c0c969e8b0eb5996b39a9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7082653fa7a8f0073bc8d9b2cdc5fcaa2f2449c4073880bba08f704d68fd2c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7082653fa7a8f0073bc8d9b2cdc5fcaa2f2449c4073880bba08f704d68fd2c07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7082653fa7a8f0073bc8d9b2cdc5fcaa2f2449c4073880bba08f704d68fd2c07"
    sha256 cellar: :any_skip_relocation, sonoma:         "be40a7a292a7ff01b6879f9304bf7cf804a2f09776b6a347afd3fc3215b7816c"
    sha256 cellar: :any_skip_relocation, ventura:        "be40a7a292a7ff01b6879f9304bf7cf804a2f09776b6a347afd3fc3215b7816c"
    sha256 cellar: :any_skip_relocation, monterey:       "be40a7a292a7ff01b6879f9304bf7cf804a2f09776b6a347afd3fc3215b7816c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfac826f6650fcc411d5af7e9d1db8cb37db9651277ca631daacfeb6e806c8c6"
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