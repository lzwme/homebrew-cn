class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.44.0.tgz"
  sha256 "78adf7a1d98fb3a7b5e7b1bb872f317f4de79155f48649c0ccce160b090de1cf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57564e43e395015b929d3444be47b4a4e4a0c4f6217e0f42aeb84e5204fcdcdf"
    sha256 cellar: :any,                 arm64_sequoia: "9f6e82ec0a0037a08c90623b2cd12f940843e31d2c90dfecf7e679e7392680f5"
    sha256 cellar: :any,                 arm64_sonoma:  "9f6e82ec0a0037a08c90623b2cd12f940843e31d2c90dfecf7e679e7392680f5"
    sha256 cellar: :any,                 sonoma:        "1910f2fb874226f172ad65d8b3b08d97c4fb6605c1e12a4d213b24e21e030947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6028bf866b7005e1d33e419ff5d17186e480698d416697c91ca6875fb60a10b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4102bb8a44125a1e855110f96f6b8bfcc38cec03c30adcbcdef364e29f7348a9"
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