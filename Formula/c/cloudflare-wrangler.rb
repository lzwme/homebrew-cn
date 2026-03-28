class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.78.0.tgz"
  sha256 "b42d648024b78d048a92018284a3ab54f313664678a77c7e0f7aed2b78ff3499"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c7f904cdd5a2f2fcd5536c45570ecc524ea83fc50d425b55d77bc5f85c55f1ae"
    sha256 cellar: :any,                 arm64_sequoia: "54cbf5dd3dad743062a5381b19a338b0f198daef8b6cb253b77e23afe22b95d3"
    sha256 cellar: :any,                 arm64_sonoma:  "54cbf5dd3dad743062a5381b19a338b0f198daef8b6cb253b77e23afe22b95d3"
    sha256 cellar: :any,                 sonoma:        "25784b853dac4afdd3ef9981ea99d6fa84da27bfaaf396b8ebeab55a59936120"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbcb9bf6627abbefd1aa314d1da6336c6ad742ba9234c27ffb73b6bf2e56471a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92c110881dbd790b4a205c45b60007cd5df0c30d8956734bc24e740852bccbdb"
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