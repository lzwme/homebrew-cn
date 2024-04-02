require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.42.0.tgz"
  sha256 "4388392d574410f43ce66e3d3a60b5fd2f43f68d7b46ea8904a523bf8af3a068"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5c67f17981f856d287e2da929950f61099d49f3fb6352cddf204487d15ee4e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5c67f17981f856d287e2da929950f61099d49f3fb6352cddf204487d15ee4e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5c67f17981f856d287e2da929950f61099d49f3fb6352cddf204487d15ee4e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "956724725cb45eb3699ec1cd07ee830b0a7843ff7e7562d70fe2fc66a238c6f2"
    sha256 cellar: :any_skip_relocation, ventura:        "956724725cb45eb3699ec1cd07ee830b0a7843ff7e7562d70fe2fc66a238c6f2"
    sha256 cellar: :any_skip_relocation, monterey:       "956724725cb45eb3699ec1cd07ee830b0a7843ff7e7562d70fe2fc66a238c6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2d43fc69367dd94ce252e39049c87b11e8afc6f3527540fcfd50133e1f7582c"
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