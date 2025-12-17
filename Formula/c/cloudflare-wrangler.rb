class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.55.0.tgz"
  sha256 "188e12b78f6043c32f725b5fee2fde3180c9ce0ba2829c2114b0bd02267867fe"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39289d7184550107ee6931e6e48a1b06c6c8e4dac122408b208a6815fc7f56d0"
    sha256 cellar: :any,                 arm64_sequoia: "e8b8dc9e12e573e088cae1d43476c90b36d1b9035e1d6449dabee87df9850e7e"
    sha256 cellar: :any,                 arm64_sonoma:  "e8b8dc9e12e573e088cae1d43476c90b36d1b9035e1d6449dabee87df9850e7e"
    sha256 cellar: :any,                 sonoma:        "01b02daac82174e790f0bf9cd5f2bb3968c7d77a588190e2e8f75ecbe8ef3666"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09abe0edc43b5bc61aad3678550ad8e0d15ff719906b018ddf02b5a07dbe9c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0307f5f813149596cd60a6a781cafc409583e7c7e84450c82d91e0d994f9a7b9"
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