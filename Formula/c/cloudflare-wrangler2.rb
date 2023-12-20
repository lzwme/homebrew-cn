require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.22.0.tgz"
  sha256 "cff3159d799b9a239a2ca08a0879785a97d3e25ebb59e2f9955d3d722c60e1cd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b533059ce64b9405a69966d0776ad6e717b4ebef9781e203da3616471c58ab80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b533059ce64b9405a69966d0776ad6e717b4ebef9781e203da3616471c58ab80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b533059ce64b9405a69966d0776ad6e717b4ebef9781e203da3616471c58ab80"
    sha256 cellar: :any_skip_relocation, sonoma:         "de39aa8a4ce302fc32874cc76dbd337bb6f589acddb04d40c994604fbc59ba03"
    sha256 cellar: :any_skip_relocation, ventura:        "de39aa8a4ce302fc32874cc76dbd337bb6f589acddb04d40c994604fbc59ba03"
    sha256 cellar: :any_skip_relocation, monterey:       "de39aa8a4ce302fc32874cc76dbd337bb6f589acddb04d40c994604fbc59ba03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cbf617687e61d0ca2e1f020fa33a4a74940edf074c62b7e2378954dafb5ae9e"
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