class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.84.1.tgz"
  sha256 "c2686b3d28fc721d39db3b2a0f855a4e1260ee0a2b542d447ff257d01eea881a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21fb4e9efc7f02801a0c22bea11470e5fade5a6c6db9ce5aa2bbe0e14c0b5508"
    sha256 cellar: :any,                 arm64_sequoia: "4525c0aef53b5d84217621011de74dbfdf2bf131ac67ba9417843f4bc45faa2b"
    sha256 cellar: :any,                 arm64_sonoma:  "4525c0aef53b5d84217621011de74dbfdf2bf131ac67ba9417843f4bc45faa2b"
    sha256 cellar: :any,                 sonoma:        "92ce46ad0fcd593050bc2720de3baf713d0484796cfeaa24de978e246c20263a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a94a3f2047349320dcf9689bb803d4b07eae65e2ae4e825a84da3f9de1460c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca605e5a9efcc9dd4acb2d2de32c5b5e934e1ed6630f2c13b995abed8fef760"
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