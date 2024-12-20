class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.99.0.tgz"
  sha256 "42aae36c41b5ff547a79166bad9a6ef11f11d4e076d356b11704ee807a7c036a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a01a68dfb8aba3d71a92f025c6e9fd1b9f4b749d988ef027af8a1e272b62258e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a01a68dfb8aba3d71a92f025c6e9fd1b9f4b749d988ef027af8a1e272b62258e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a01a68dfb8aba3d71a92f025c6e9fd1b9f4b749d988ef027af8a1e272b62258e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c993fbb15aac6817884c08410777738773a113062b13fa4c1f26d0373e4c305"
    sha256 cellar: :any_skip_relocation, ventura:       "2c993fbb15aac6817884c08410777738773a113062b13fa4c1f26d0373e4c305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f534a8129100b7ded3a2f4cfc6c9e9d673820c4551570436dd32c8d0fcabd9e8"
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