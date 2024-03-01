require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.30.1.tgz"
  sha256 "13a33a6391b3d536ec6fa027d3e4017200bac2bc6d1d24956acb70563667ed1a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ffafbb1833bd1001df8dc19ba65d9dc15d0b7e78006c7b590204ee392bd498a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ffafbb1833bd1001df8dc19ba65d9dc15d0b7e78006c7b590204ee392bd498a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ffafbb1833bd1001df8dc19ba65d9dc15d0b7e78006c7b590204ee392bd498a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0217f3bc46a18993d2d6098d9dc80116912ae5f450c7d70c3ae4e7bf0a99b6e"
    sha256 cellar: :any_skip_relocation, ventura:        "e0217f3bc46a18993d2d6098d9dc80116912ae5f450c7d70c3ae4e7bf0a99b6e"
    sha256 cellar: :any_skip_relocation, monterey:       "e0217f3bc46a18993d2d6098d9dc80116912ae5f450c7d70c3ae4e7bf0a99b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcdf1a173ea8a5db462b27849fbf0319b7dd5bb4396410c952f855f8df0aadec"
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