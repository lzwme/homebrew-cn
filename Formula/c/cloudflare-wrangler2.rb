require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.41.0.tgz"
  sha256 "22cb8dbbf806cd7e49091869e6742f0eeade8013c0a8fa2be6664099daea2e7f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f72496850215b155adaf8b5834a242cf6c42f629aef247bdeefb3a388b23f03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f72496850215b155adaf8b5834a242cf6c42f629aef247bdeefb3a388b23f03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f72496850215b155adaf8b5834a242cf6c42f629aef247bdeefb3a388b23f03"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6fcd5ad557f597a99370c0c77fa56ad89fce7bf6d9d4fe854d4de8df3057640"
    sha256 cellar: :any_skip_relocation, ventura:        "a6fcd5ad557f597a99370c0c77fa56ad89fce7bf6d9d4fe854d4de8df3057640"
    sha256 cellar: :any_skip_relocation, monterey:       "a6fcd5ad557f597a99370c0c77fa56ad89fce7bf6d9d4fe854d4de8df3057640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27ecc3b70074819a9da4625c7266f537c3b19e24218866cda73042ff2b8a9c00"
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