require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.44.0.tgz"
  sha256 "b5bf25b63fba4843a8d66ed88df20a9d50f0d34c02968bf999dda1bafcb40e81"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d445bf0fb9777fc5e6a00fd29c1ce4bbf3bdaff2ddde28a7b1a0a0e75c31cad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d445bf0fb9777fc5e6a00fd29c1ce4bbf3bdaff2ddde28a7b1a0a0e75c31cad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d445bf0fb9777fc5e6a00fd29c1ce4bbf3bdaff2ddde28a7b1a0a0e75c31cad"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9866ac43338fe569f6ae3360f54548bbfb84929048ba30525874d6210f46a83"
    sha256 cellar: :any_skip_relocation, ventura:        "a9866ac43338fe569f6ae3360f54548bbfb84929048ba30525874d6210f46a83"
    sha256 cellar: :any_skip_relocation, monterey:       "a9866ac43338fe569f6ae3360f54548bbfb84929048ba30525874d6210f46a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9d52494b0eed96437785b4137c4469e0ff0dfe02a0d6611d89b5c75bec5e31d"
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