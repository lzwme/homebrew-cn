class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.60.0.tgz"
  sha256 "200f59b2bf26f686a014eefd59ad840913c729d9ab345015e11976ff8a857e39"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f9d1c10952400350097e42d46d8d1300d403586a40efd7b6d6effc2e7664732"
    sha256 cellar: :any,                 arm64_sequoia: "2aeabdb524bdc2c33b5592052f11fbaa13fa006016967450120314f7670a6a79"
    sha256 cellar: :any,                 arm64_sonoma:  "2aeabdb524bdc2c33b5592052f11fbaa13fa006016967450120314f7670a6a79"
    sha256 cellar: :any,                 sonoma:        "d8718eddfcd9ca899b3ff12f654dbcc84b882b5e7c7d22fb0dcb1cabf1ecd068"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe7574abc87095fed0ac729ca32dfc5d1fa9ad4df90bd92573d5206ff080e684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0201a8bca3fa2c78966a8512cec09d9ad3b778e63a886807c353947a3cbadcc0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end