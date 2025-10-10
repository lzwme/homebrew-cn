class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.42.2.tgz"
  sha256 "069573cac19f07bd0006e6e461979d86b3820fac29ce12087fa2d4e5187ab2df"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e6ee2b792a4d2e15db0000690b17a4302cec5e91c429fbe6055af857ca4cf39"
    sha256 cellar: :any,                 arm64_sequoia: "e363f6a9078cac83de2059e0f3d6ecbf3345fd24958fa624ec98129a7490626a"
    sha256 cellar: :any,                 arm64_sonoma:  "e363f6a9078cac83de2059e0f3d6ecbf3345fd24958fa624ec98129a7490626a"
    sha256 cellar: :any,                 sonoma:        "13a1bddb7d1c4ade02fb7104199d22fc175ef2ad46de85af86a49a44cf6a92cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36950db2af462d7699d9f1e91caeaf297e124dec9a65c8579dba64c5e500d0a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b748d99a95d403eb20b5bf6afa3f055679ed0ddc2de0b48f58ea0300aafab625"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end