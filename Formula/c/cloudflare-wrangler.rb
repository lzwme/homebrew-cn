class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.87.0.tgz"
  sha256 "dfc470dbb92b9d025a4c92645fb028fd1c6df893448c4e9178f084703781e86f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbda2b586496d62d04eaf833b28fc533863143e4f5410f00238d0ee5ad7b635b"
    sha256 cellar: :any,                 arm64_sequoia: "f2ce2f215bcc0e1cdee7a4c64c452bd4c38dd38205064d130e31cb84dbddb9b7"
    sha256 cellar: :any,                 arm64_sonoma:  "f2ce2f215bcc0e1cdee7a4c64c452bd4c38dd38205064d130e31cb84dbddb9b7"
    sha256 cellar: :any,                 sonoma:        "8719aa60ddfabae74b6b993848a4d3c74b8203027b63af9a050335d01c296f71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90ff91a1f957159395f06c2fd581724656216b4606eb9d778eef0e4ddf4b8967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e7e8fa1c1e4f5ab9a800affbb0c5f87a6c0d58e6e42591c2e3a62cc1590fa3c"
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