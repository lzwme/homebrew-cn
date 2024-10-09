class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.80.2.tgz"
  sha256 "73683b973b7da3c8c4d00629426240640b5bded5436fc3f118b8db22769360bf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "954526f4ca2b192967670e3a570714aaa52750fee770efa0f6549927b7eb85fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "954526f4ca2b192967670e3a570714aaa52750fee770efa0f6549927b7eb85fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "954526f4ca2b192967670e3a570714aaa52750fee770efa0f6549927b7eb85fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b9a9c1ddafbc426a5e6f530905c6bb1f6098fc4503524daa8cab088666150cf"
    sha256 cellar: :any_skip_relocation, ventura:       "3b9a9c1ddafbc426a5e6f530905c6bb1f6098fc4503524daa8cab088666150cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f9bf6153a3677ca43ea22ec9b33de6b57d2536d073a5898051dcee09daae5c7"
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