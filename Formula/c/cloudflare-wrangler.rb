class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.77.0.tgz"
  sha256 "4da96a17f64fdbf65552d64b7b5d304fbe293d6d22fb0dc36bbab8e0bc6976a9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6aaefaeb97753633a2a6d6ee850a14c021bc7852cd3cc1bf94cc71a84893c8e6"
    sha256 cellar: :any,                 arm64_sequoia: "6eb7d50d34dcf0bdd3c09ce04db90cd21ba1bfdd2bbcf17ede0eef7c95585011"
    sha256 cellar: :any,                 arm64_sonoma:  "6eb7d50d34dcf0bdd3c09ce04db90cd21ba1bfdd2bbcf17ede0eef7c95585011"
    sha256 cellar: :any,                 sonoma:        "f05dcd0fb998f24cbd327cd90178f63680a0b12c32ae37f706671fb3cf21852b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c0a25f20358fb45b069ca3e137fa38b493692cf050819d95ef6733fc47eadbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb40502c07544844fd390c1373bccc8c20ec7d159daa696d44a3b6fb5f65327"
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