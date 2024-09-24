class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.78.8.tgz"
  sha256 "e5fefa33bbec1927cbd9661e82b3bd8ae2fb10e706a6dbadbf45c8fcf1f35260"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7833da874cb100b7a91a1882540843da082aa469427ae9106ddcb4c5cf146475"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7833da874cb100b7a91a1882540843da082aa469427ae9106ddcb4c5cf146475"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7833da874cb100b7a91a1882540843da082aa469427ae9106ddcb4c5cf146475"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7681fb89f3cf87fefa2dd787dd9de06b4157a4485109beacc16b43d3fb28720"
    sha256 cellar: :any_skip_relocation, ventura:       "a7681fb89f3cf87fefa2dd787dd9de06b4157a4485109beacc16b43d3fb28720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "324acf19ea27b27b3f74a3565ea1c4863538fe71541238da6991c9972235ccca"
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