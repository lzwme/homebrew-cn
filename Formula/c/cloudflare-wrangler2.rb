require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.28.1.tgz"
  sha256 "66165589776cf896a73cdeabe93ae026c3580c5b0d85667036d7fe4255edcca6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe51fe938b9a9535f496b35d676195504670d86a3bed0a3409cb9799bce4a173"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe51fe938b9a9535f496b35d676195504670d86a3bed0a3409cb9799bce4a173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe51fe938b9a9535f496b35d676195504670d86a3bed0a3409cb9799bce4a173"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f45dd305772aabc22ebea2ae2082642262463ebe5948ba31c85b106cc3857c0"
    sha256 cellar: :any_skip_relocation, ventura:        "6f45dd305772aabc22ebea2ae2082642262463ebe5948ba31c85b106cc3857c0"
    sha256 cellar: :any_skip_relocation, monterey:       "6f45dd305772aabc22ebea2ae2082642262463ebe5948ba31c85b106cc3857c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd305b7964e124e9cf99d1f47a627d3fabda835a30f16456fb0e2ad790b47755"
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