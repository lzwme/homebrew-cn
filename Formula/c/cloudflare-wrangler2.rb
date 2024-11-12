class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.86.1.tgz"
  sha256 "dc21e44b8c2a21c72d7fb9044e21ddf841975151942a69aa51384dbe2367cbfd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1f31fdadd5f4f8318e72b29677f46e058e89c761ac6a7ad88c38c9998d635a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1f31fdadd5f4f8318e72b29677f46e058e89c761ac6a7ad88c38c9998d635a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1f31fdadd5f4f8318e72b29677f46e058e89c761ac6a7ad88c38c9998d635a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d34df5678ead913aa2a40226137bd0d40d0bc0849eb5a671df130a85e25a285"
    sha256 cellar: :any_skip_relocation, ventura:       "4d34df5678ead913aa2a40226137bd0d40d0bc0849eb5a671df130a85e25a285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "632353f4ecd693e6387907f95458f4b675c32f0fe6a16f455314b60b8742e14a"
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