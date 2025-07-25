class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.26.0.tgz"
  sha256 "c1f07db18c284ce1764c541481bc7d18eee4ae785dbfd6413e5932adc036ad39"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ea91d25fb00ee978a6049516f1fdc92ed7e56bc0e702fdc42ca2cc637c40558"
    sha256 cellar: :any,                 arm64_sonoma:  "8ea91d25fb00ee978a6049516f1fdc92ed7e56bc0e702fdc42ca2cc637c40558"
    sha256 cellar: :any,                 arm64_ventura: "8ea91d25fb00ee978a6049516f1fdc92ed7e56bc0e702fdc42ca2cc637c40558"
    sha256                               sonoma:        "2568348e8e06d7aa95e6ccbfee6a8d85d05dc0799bd27b67fd48464b79dd5d93"
    sha256                               ventura:       "2568348e8e06d7aa95e6ccbfee6a8d85d05dc0799bd27b67fd48464b79dd5d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4caffa6a1ad83be3ff823c9079b9f62c98a45f0444297159137a41cbb2f7ff42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13c2b90861aef03851218bb09bc5250efb6bcefcd34357a2baa0034b35cf91bc"
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