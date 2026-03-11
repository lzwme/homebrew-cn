class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.72.0.tgz"
  sha256 "86e6b7f831366c31705dd45b2ad36b71eebdb2aa334a575f1d8ff8ed4834a370"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6b7c58a46d5c7bf2532e832382a421f925b500ec7d337eb2d5dcb4874239a19"
    sha256 cellar: :any,                 arm64_sequoia: "5954d3e5b5ae277ea21686f9001eb996aede9caca627452365fec18652c40eb9"
    sha256 cellar: :any,                 arm64_sonoma:  "5954d3e5b5ae277ea21686f9001eb996aede9caca627452365fec18652c40eb9"
    sha256 cellar: :any,                 sonoma:        "46817b86eb431751f316b5fa896bb82ae024697b885e47060e87cbcf8a317bb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "230b11d6e622cfb87767ca91ca800183dde13e1acfa1e4afeb811948a672664e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcff5c6602974492de33addf2c2fa0daaa3504ad6b3f5902c99ca1a200ad7436"
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