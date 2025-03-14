class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.0.0.tgz"
  sha256 "1bd9597d1d29a3c14030c13eb0423267f9a6b4f3bc2d29d69134cc7109e32d42"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf749d07960cb71a5e1e4d8a3f559fdbbf99ad10a54c8adfc17e3f421f78ee2d"
    sha256 cellar: :any,                 arm64_sonoma:  "bf749d07960cb71a5e1e4d8a3f559fdbbf99ad10a54c8adfc17e3f421f78ee2d"
    sha256 cellar: :any,                 arm64_ventura: "bf749d07960cb71a5e1e4d8a3f559fdbbf99ad10a54c8adfc17e3f421f78ee2d"
    sha256                               sonoma:        "87ebc2031556e4fe36d494bc5f3b0074108655e6df4212bf713fb1fb501c8715"
    sha256                               ventura:       "87ebc2031556e4fe36d494bc5f3b0074108655e6df4212bf713fb1fb501c8715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1ff64d174f7cedaed46f0d1dc9b27a1e3d3a479d150fc328284fbf3e8e3ed6"
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