class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.16.0.tgz"
  sha256 "cc687dac058922de018366e2d654d21f4a9672329c223fea127f69c384f0abaa"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1465c46f97621a4e8aeca73a354c1fe8071f046939c4cb029a64693d1feb913"
    sha256 cellar: :any,                 arm64_sonoma:  "a1465c46f97621a4e8aeca73a354c1fe8071f046939c4cb029a64693d1feb913"
    sha256 cellar: :any,                 arm64_ventura: "a1465c46f97621a4e8aeca73a354c1fe8071f046939c4cb029a64693d1feb913"
    sha256                               sonoma:        "f5ffd65e36ca8dce7507f313d84d5b8c03b008cce289a9471c0102424712e5df"
    sha256                               ventura:       "f5ffd65e36ca8dce7507f313d84d5b8c03b008cce289a9471c0102424712e5df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dabe9c9eff2a0768627d6c14753f24baae6ce69d4b8b6973df80ae5a57b204b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecde0f6e22c911bf7ec080cabbba6d42968f728346f6e454b85fa4bdfc513f2c"
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