class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.45.0.tgz"
  sha256 "3fae74ec39ed3c42cbf4201611c9513e811c32bd009963f6090ad7af92a9d6bc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66e3bd61f3639420c8b1738d9afe3426c38f4777138556b0c3271f5cdce7a24a"
    sha256 cellar: :any,                 arm64_sequoia: "c352a8f4b6e3ed40b2307686cf5d6dcf4faad31c5c9dd2e01060de05c7128016"
    sha256 cellar: :any,                 arm64_sonoma:  "c352a8f4b6e3ed40b2307686cf5d6dcf4faad31c5c9dd2e01060de05c7128016"
    sha256 cellar: :any,                 sonoma:        "0ea0c61b0baa55bb15d1c602d0df13695608004a3fa728bb60313218d16c2c74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d26513afe54d9d951429f2886169a525f6f82999395c9a8701dcb3be3ebcf7e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3610e7eba675900e1b27bec3b74f8698f48d347edd54e70b178b5e18fa335854"
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