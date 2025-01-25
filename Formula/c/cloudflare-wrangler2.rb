class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.105.1.tgz"
  sha256 "97d1769d1106a1917a0da660408eac28f811f7420516690dcb2c98aea56dc013"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7faec81bdca9714905c093143e55a423a8e8376045ecd7f833fdc3fff1123da9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7faec81bdca9714905c093143e55a423a8e8376045ecd7f833fdc3fff1123da9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7faec81bdca9714905c093143e55a423a8e8376045ecd7f833fdc3fff1123da9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ecf309bd5b336aabc0a693f74e68f035e65c2715fabb995742436dd7a4fd5ca"
    sha256 cellar: :any_skip_relocation, ventura:       "9ecf309bd5b336aabc0a693f74e68f035e65c2715fabb995742436dd7a4fd5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123cb41d100ec68412b5243eb70cae38bc3be20c57271d41d2ba333ec453adec"
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