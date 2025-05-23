class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.16.1.tgz"
  sha256 "c0d89a48c2baf9c3fb19e98671f8e4719895160a33418a0748b2a8ce3a313e9b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e85155f742c03eb53a56f2b984e71df04a7e96fb7df0d2678d919d20bc550e79"
    sha256 cellar: :any,                 arm64_sonoma:  "e85155f742c03eb53a56f2b984e71df04a7e96fb7df0d2678d919d20bc550e79"
    sha256 cellar: :any,                 arm64_ventura: "e85155f742c03eb53a56f2b984e71df04a7e96fb7df0d2678d919d20bc550e79"
    sha256                               sonoma:        "1fdd6cfd23b4d17f99109322a98a3f7fb1d3473a9efab73ac5b0fed8c80ea4a1"
    sha256                               ventura:       "1fdd6cfd23b4d17f99109322a98a3f7fb1d3473a9efab73ac5b0fed8c80ea4a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c69ccb624919fc46d224ce2f6ccf2f4df1e2a494920bd7ac2753d2a0708b01a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "838c4461a508e0217885e744102331948800d9df9888a57dde4896e523348dfa"
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