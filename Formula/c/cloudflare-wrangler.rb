class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.54.0.tgz"
  sha256 "cd83a23155f04b81cce6a8f7463d4960ccf87d9d95eb2625cb2410e974039255"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "577e2e785f796152a2a862876331e1268c5666f9c0872e7d9f41121ae91298c6"
    sha256 cellar: :any,                 arm64_sequoia: "ad2b49040a04270223b1758f23d304b48f3602cf4b0cf6784c881aa2ca68b9f3"
    sha256 cellar: :any,                 arm64_sonoma:  "ad2b49040a04270223b1758f23d304b48f3602cf4b0cf6784c881aa2ca68b9f3"
    sha256 cellar: :any,                 sonoma:        "13c814371f227bf10d95926af5d3b75ea08132fb449837d822a691b1e27a58e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b536156b370863cd592ba09aa40e483363217ca1bda23967d45f63d22078255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892cdddc701c89e89fa1f0d686c8afb9f32c2b09ee6bd060ab2da525b4a5e693"
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