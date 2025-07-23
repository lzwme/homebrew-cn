class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.25.1.tgz"
  sha256 "f7b05507ac56ace567b501d8f4a5f9251070fc348c43bc66349d5fa2cda03015"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69523dffaaab8f05ab3eec74af139c384ce92e682cf0663b835e5866bf54e645"
    sha256 cellar: :any,                 arm64_sonoma:  "69523dffaaab8f05ab3eec74af139c384ce92e682cf0663b835e5866bf54e645"
    sha256 cellar: :any,                 arm64_ventura: "69523dffaaab8f05ab3eec74af139c384ce92e682cf0663b835e5866bf54e645"
    sha256                               sonoma:        "717e40868145748ac75a1e9da42faf42316f33ef30028b7cf3b5918b33b1ee6f"
    sha256                               ventura:       "717e40868145748ac75a1e9da42faf42316f33ef30028b7cf3b5918b33b1ee6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1564692dbae2cc688542371e7e1ecbd28ba7fd4b394c5a57ace141e070982245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41aa0e1ab8a5035dbe146da044db67403078bb603d53a9c786a386fc83e3631e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end