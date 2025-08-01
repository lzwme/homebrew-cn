class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.27.0.tgz"
  sha256 "62342e7fd6e894e91df0cdf7724094235899a30aa6d711dc1d097f063474b1af"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "11dfaa2e2aae8b30058225b1bbd8ef5b5bb3fd8bdc070db84c7d2acfd401fb08"
    sha256 cellar: :any,                 arm64_sonoma:  "11dfaa2e2aae8b30058225b1bbd8ef5b5bb3fd8bdc070db84c7d2acfd401fb08"
    sha256 cellar: :any,                 arm64_ventura: "11dfaa2e2aae8b30058225b1bbd8ef5b5bb3fd8bdc070db84c7d2acfd401fb08"
    sha256                               sonoma:        "43dabdae4172ff6cf70a490331be2154c4aa03d58f7df97d0c281eaecc1ccb89"
    sha256                               ventura:       "43dabdae4172ff6cf70a490331be2154c4aa03d58f7df97d0c281eaecc1ccb89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "392d3041dec9eeedd734a9d596ef30850bb92b83792542517afdc04bb5d71f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90df9f8f58aa6a8a146f65c754692828c42af624aeb1092af656eb06460de048"
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