class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.23.0.tgz"
  sha256 "4a3942330192e432f1b1bfbe3bec748dc563d24341e86decf95d596c8e84d1fa"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37651fce79d8854eb20054bd51fc674fa325795aecf4e93269b6cc40cb86be18"
    sha256 cellar: :any,                 arm64_sonoma:  "37651fce79d8854eb20054bd51fc674fa325795aecf4e93269b6cc40cb86be18"
    sha256 cellar: :any,                 arm64_ventura: "37651fce79d8854eb20054bd51fc674fa325795aecf4e93269b6cc40cb86be18"
    sha256                               sonoma:        "dcba9ad2a8d9941854e589f4103b0f33319f1d8d315a1164d27a8aba9d331821"
    sha256                               ventura:       "dcba9ad2a8d9941854e589f4103b0f33319f1d8d315a1164d27a8aba9d331821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf4051dd8a050325047a27abde59278d2b8aceb4f9fe4ada0996c1405c7b933d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde81f02ef17c0258e2c01154eb968b36b9e4283680959c84e85fd59bfcac7fc"
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