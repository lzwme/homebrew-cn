class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.82.0.tgz"
  sha256 "adf2e4b7e0726122bcc738da8e858ff041b01c59253b22724a68167e17a37aaf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45e23f588f8f821844c4d63a85e5c43a9730ba005462ae9a134d70335e5e0352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e23f588f8f821844c4d63a85e5c43a9730ba005462ae9a134d70335e5e0352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45e23f588f8f821844c4d63a85e5c43a9730ba005462ae9a134d70335e5e0352"
    sha256 cellar: :any_skip_relocation, sonoma:        "9357740dcbe014856630a5775e26689c904b007727b95f67f26d2dca9b48eeb5"
    sha256 cellar: :any_skip_relocation, ventura:       "9357740dcbe014856630a5775e26689c904b007727b95f67f26d2dca9b48eeb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2c4a2b2b8b5b77a231fe52f18a0c692b16474ea9c601eec7fbf6b32bfaab4c7"
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