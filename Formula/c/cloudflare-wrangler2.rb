class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.107.0.tgz"
  sha256 "cb6124f9352a302e8ac7af8391e3d8f9f832f4216c061200db88b9e4ed300eb7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb54939fe1afc40948de4b630dc35f4217871badbf6769c890fc36f2052ce5c5"
    sha256 cellar: :any,                 arm64_sonoma:  "bb54939fe1afc40948de4b630dc35f4217871badbf6769c890fc36f2052ce5c5"
    sha256 cellar: :any,                 arm64_ventura: "bb54939fe1afc40948de4b630dc35f4217871badbf6769c890fc36f2052ce5c5"
    sha256                               sonoma:        "7811715e9e1e3e58949d4b991de8836a1334bc172af8e190a18f6a3760e8513b"
    sha256                               ventura:       "7811715e9e1e3e58949d4b991de8836a1334bc172af8e190a18f6a3760e8513b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adfb867307a3f77595b663544179712b91cbf6c6d811a09638f59df42cd4ee09"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end