class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.2.0.tgz"
  sha256 "c3616e02074df7ef09c618229f9f8e526a58a87d19915151879e8fe921ec05ad"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "13f2da1a679ed9058def169075abd03de3707db0b21779c3475229b5029e1470"
    sha256 cellar: :any,                 arm64_sonoma:  "13f2da1a679ed9058def169075abd03de3707db0b21779c3475229b5029e1470"
    sha256 cellar: :any,                 arm64_ventura: "13f2da1a679ed9058def169075abd03de3707db0b21779c3475229b5029e1470"
    sha256                               sonoma:        "e7403b46f9eba133520b5143bf373350fe961fcd4237fe7aa84045035c6a7f1a"
    sha256                               ventura:       "e7403b46f9eba133520b5143bf373350fe961fcd4237fe7aa84045035c6a7f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "607f7daaf4b539adbfad84309adc4de9a8cf5745ca7260f33408dbfcec7d972f"
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