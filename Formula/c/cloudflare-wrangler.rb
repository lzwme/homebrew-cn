class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.112.0.tgz"
  sha256 "ffd40e80552dea8ff8516496a632d014b9d54562d81144e68da477b455f6a665"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ed2a814320fa225204be66724a0084bddc545aa7de29596d6d28ca964056c11"
    sha256 cellar: :any,                 arm64_sonoma:  "2ed2a814320fa225204be66724a0084bddc545aa7de29596d6d28ca964056c11"
    sha256 cellar: :any,                 arm64_ventura: "2ed2a814320fa225204be66724a0084bddc545aa7de29596d6d28ca964056c11"
    sha256                               sonoma:        "eecb06bf2acf7c3d45697964abd1dc69eb9a1130b94157a091b7c1a52930093e"
    sha256                               ventura:       "eecb06bf2acf7c3d45697964abd1dc69eb9a1130b94157a091b7c1a52930093e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "618bb31c458936b110baa9b24c3b398b92a9171f5a3d89b4123ea0db867a9829"
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