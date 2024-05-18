require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.57.0.tgz"
  sha256 "7a6afd72598a2bf173108810e3f5f2dcf24e7d4e6984db6f449cdfda5031331d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "031e6eb694d1bd682344f74c7a658cb3f1a56c6d9d0e96419bc2842ec4d226e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b159bf86cb6ec3cda8ddd4fcd974bee19ff1ccc20265415bcbf49322d80ea3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3776a14f7fa7b19cc231dffa3e9d5b1a0ddf0419d56917467922befe752d8da2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dc809d604abc122a4843694e3fa44a8df0dc97d60b9c6b5dc9c4775f6664d90"
    sha256 cellar: :any_skip_relocation, ventura:        "ca0e4021d4482a05d4ba19c5cf26d962b75f7fac72ee13aad1c910cf8b7fc48f"
    sha256 cellar: :any_skip_relocation, monterey:       "d4255f4b49952af8518eb23d3e7e7c6442b9af1ff4b6cfcfc65788cff62b73c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1396ba1909f612fbcebf97d8c927e710f9b902f82f43e7914c8561f9627d544a"
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