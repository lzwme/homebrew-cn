class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.68.0.tgz"
  sha256 "03d96ad26e98beea942233cfd882c758181ac6d2f0794deb85460753b2e5afe0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96e451cb994cc4959050e123620f83fa64bcd7555b3900b28dd18f062bf9802f"
    sha256 cellar: :any,                 arm64_sequoia: "4ab4040bae0115e8d98848c16fe25be49aba9dd780c4f0358e806ffe782e04e3"
    sha256 cellar: :any,                 arm64_sonoma:  "4ab4040bae0115e8d98848c16fe25be49aba9dd780c4f0358e806ffe782e04e3"
    sha256 cellar: :any,                 sonoma:        "c90d219be6664d2620bbf0bea5231d57fcd2fba0adba962b4b60eadb55c314f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd9c39263a1fb100211994b206ad438110aba7e47bf9da55b4f7c45fbbfbaae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b575f42c3cbe2d380f17098d5796cacef2c72011ef0a36a1bfd7a57dad49a6"
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