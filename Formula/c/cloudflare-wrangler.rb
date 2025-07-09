class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.24.0.tgz"
  sha256 "4bb35a07b650a5c358f96aa7b8f89ba9044c36ad8e4c71f89f2ace1914bad39f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6718c22d33dc93e7aeb628396c4b54303f0774c3962fce88e6482944b69acf1a"
    sha256 cellar: :any,                 arm64_sonoma:  "6718c22d33dc93e7aeb628396c4b54303f0774c3962fce88e6482944b69acf1a"
    sha256 cellar: :any,                 arm64_ventura: "6718c22d33dc93e7aeb628396c4b54303f0774c3962fce88e6482944b69acf1a"
    sha256                               sonoma:        "87a8e37a0c90a42a205f4633138e539d75a3823bb85e85a31f5135441017e389"
    sha256                               ventura:       "87a8e37a0c90a42a205f4633138e539d75a3823bb85e85a31f5135441017e389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b4d8e0a9f10baa801804809f8d697b7e1031ec8e1182defbde6f91f86f1ab7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1975077e5e6ee1f3a3b79286b213480481e90bd7361565e6bff31f12ccc9c71"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end