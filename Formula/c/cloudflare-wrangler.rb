class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.53.0.tgz"
  sha256 "4e7b1db8957984d18eeef63457217dc7c7074276068c80ad8ce0b8bde3cb624e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e22dbcf750b2a40f6736e3e089344764988e4983b0a7e745e87849051585b8d5"
    sha256 cellar: :any,                 arm64_sequoia: "e42f1bb2bc028cb27e406c712791fce774c2ea4389d5005f8c4285f5f2273c85"
    sha256 cellar: :any,                 arm64_sonoma:  "e42f1bb2bc028cb27e406c712791fce774c2ea4389d5005f8c4285f5f2273c85"
    sha256 cellar: :any,                 sonoma:        "f9da8955fb861c682ef3794c721c04d94e2144701f81feb4bccaa7340295389b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a6fe0bd2ba339ce9a821330d149192a7c6c2a49f4b7cdad22d848235274710a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "085de85585699295af2ae7bb211de74fd760273c9a18340177b3ae7d8da32d9e"
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