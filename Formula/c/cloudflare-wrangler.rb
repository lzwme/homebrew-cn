class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.33.0.tgz"
  sha256 "68402fcba6854645bd40117e82a5666f989c48795c86e33362f0a28c99dd4353"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "71cc88bd2f20c486d527269f40655c98690a961687a4b08020ffa9215e684f18"
    sha256 cellar: :any,                 arm64_sonoma:  "71cc88bd2f20c486d527269f40655c98690a961687a4b08020ffa9215e684f18"
    sha256 cellar: :any,                 arm64_ventura: "71cc88bd2f20c486d527269f40655c98690a961687a4b08020ffa9215e684f18"
    sha256 cellar: :any,                 sonoma:        "ca653bd7f3a961dcd95097bcbc5a553cc31d8a902db832c2477e8dd90f530e04"
    sha256 cellar: :any,                 ventura:       "ca653bd7f3a961dcd95097bcbc5a553cc31d8a902db832c2477e8dd90f530e04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28abca363bfc56722c073091b1e2d19d40008f9ec10e8b0769cfe9ae6431bde4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d83f544c155a31d8cb9487e6e45c54fbfae6e0afff377cd0d654086465e2078"
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