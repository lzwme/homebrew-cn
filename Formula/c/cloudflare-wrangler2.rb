class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.75.0.tgz"
  sha256 "b1110347ba9a311bbcf63b0b33c8f747fa6b647e48c494f7291094b7401d523f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74ba048102c728c06b82f31620df3f2132001f7b2ece373d0fc6a2d4d9e24f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74ba048102c728c06b82f31620df3f2132001f7b2ece373d0fc6a2d4d9e24f3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74ba048102c728c06b82f31620df3f2132001f7b2ece373d0fc6a2d4d9e24f3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "92c368da588b703543e25fc20af484fb2a24de0ab31bfcd2c3a42d9b992cc3d0"
    sha256 cellar: :any_skip_relocation, ventura:        "92c368da588b703543e25fc20af484fb2a24de0ab31bfcd2c3a42d9b992cc3d0"
    sha256 cellar: :any_skip_relocation, monterey:       "92c368da588b703543e25fc20af484fb2a24de0ab31bfcd2c3a42d9b992cc3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0931338d6ef74c6af05ef92e461cf8ece0020eca8ca0069d8cc4cf5684282c0a"
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