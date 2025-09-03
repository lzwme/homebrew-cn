class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.33.2.tgz"
  sha256 "bab4ae5ba9605d82cc73e14b8a341aef3b41fd08a4a62f8d2fb8cb770bdf1640"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce5189500abb5900d8141d3764c4f29f169b5ab3e7abe45cfaac62b261d0b6c2"
    sha256 cellar: :any,                 arm64_sonoma:  "ce5189500abb5900d8141d3764c4f29f169b5ab3e7abe45cfaac62b261d0b6c2"
    sha256 cellar: :any,                 arm64_ventura: "ce5189500abb5900d8141d3764c4f29f169b5ab3e7abe45cfaac62b261d0b6c2"
    sha256 cellar: :any,                 sonoma:        "762e5386b8158904f39aecb9ebd0bcf52331148936cf13f57162416e9c27e6f8"
    sha256 cellar: :any,                 ventura:       "762e5386b8158904f39aecb9ebd0bcf52331148936cf13f57162416e9c27e6f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b47cb80a6eff35e19f63a4ce304508017ddbb3e382f963875988c41c743ccc97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc1a385c29f9bea6c6030965842951fbed05f1938fc1b4d482af1d967bbc075"
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