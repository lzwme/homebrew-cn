class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.52.1.tgz"
  sha256 "0aae8212e9445d839d3df7ec3f7ffe0bce1acb9575a0ac934460252ab01acc54"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95d2f773c145b49cfa604c380f42e00e39580b75118f56a3f688e234e75da84e"
    sha256 cellar: :any,                 arm64_sequoia: "9c254da96d2f8613a4c386615ca10756fba3fc62f46ed1886025c0cad6e877ab"
    sha256 cellar: :any,                 arm64_sonoma:  "9c254da96d2f8613a4c386615ca10756fba3fc62f46ed1886025c0cad6e877ab"
    sha256 cellar: :any,                 sonoma:        "98d343608ea4af91a47dda62227b1b12d35445053321e6f2dca65486f76d2816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02f7624a72adfabfcc8a69333e8a31facf51b1334624efa9878799e6a09c8937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "843aaa491ea5119807913544d5552b534d693d9f96270e9b0aa92ac028ebccd9"
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