class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.106.0.tgz"
  sha256 "b34163007c3ae1dbe7ed72ade952d25db9605adf216d1ff687f8594705fb1283"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b8ea1fe550f2c59a0e397b138b891ecfed0c15f2a63ea5ee60a45fcd4f25427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b8ea1fe550f2c59a0e397b138b891ecfed0c15f2a63ea5ee60a45fcd4f25427"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b8ea1fe550f2c59a0e397b138b891ecfed0c15f2a63ea5ee60a45fcd4f25427"
    sha256 cellar: :any_skip_relocation, sonoma:        "325861ce34dd4e257809e3503ee3499066229d3a66fc829888fd741e90a98ea8"
    sha256 cellar: :any_skip_relocation, ventura:       "325861ce34dd4e257809e3503ee3499066229d3a66fc829888fd741e90a98ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef72070d2892899a17c312f06d14c7fdec8de24ecec4e894a5af0ba949d42a6"
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