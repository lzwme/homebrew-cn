class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.59.1.tgz"
  sha256 "f38eb0e278dc0c56873d138aadb0a12e4c03aee8d567163f71fc4a30d393d5f1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "86d17655ba13d80e628d37e8c7f5c56a246522e72e33c3c4e6292f89a4eddcf7"
    sha256 cellar: :any,                 arm64_sequoia: "dadc763b7be37e60b7a0a1e1c91adc604b65dd80610de47368dc11389580bd32"
    sha256 cellar: :any,                 arm64_sonoma:  "dadc763b7be37e60b7a0a1e1c91adc604b65dd80610de47368dc11389580bd32"
    sha256 cellar: :any,                 sonoma:        "d645447adcfa0c0481ae1c3a58bd92ac9df167f10e9c3c9fb489fa3427d2da68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10cefd2c5bb3953a58e118700e6937826760674e96563407a381cf2a31c1a99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eee6c7ea1e96138fa9a2d0d87122fb7ace606b33a736b7293d55f83a30b3bf57"
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