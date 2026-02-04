class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.62.0.tgz"
  sha256 "abf9d0e3cdab3dde4cef18040eff6ba9eacd47d8730da4b07e7930298c73de5d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc3f3ff0e06f79307d2226adc57815ff5e0cf8959f55340eb7a7f2c0fa807a02"
    sha256 cellar: :any,                 arm64_sequoia: "0987ca60b028b1e6d53d179d0961ddf35ab83d304f15a447fa4a3f99bcc82647"
    sha256 cellar: :any,                 arm64_sonoma:  "0987ca60b028b1e6d53d179d0961ddf35ab83d304f15a447fa4a3f99bcc82647"
    sha256 cellar: :any,                 sonoma:        "3ebf46a93d524eed4efe360f8bb340bdef407042fd00d36d5882675308876e56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48fe45dcff68dec56451602a3f422d9348ffcbb244b8933552acacd0a44a0cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c48b27b9de5ec0ab2821df1d2e9cd66823d849baf2adb3cf28423b2b532353f"
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