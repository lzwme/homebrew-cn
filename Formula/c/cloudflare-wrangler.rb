class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.75.0.tgz"
  sha256 "38ce5ed8fb3e348a6073e6c85c26997438961b479d77c36a48902ad8f9afd88c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3269a36b86aadf3c3bbff6a8b6bcdec0452bc4714a173ce5c6d8a609a88c0f3"
    sha256 cellar: :any,                 arm64_sequoia: "efe286db670277512063d4cde57c5e363fdb2628f98cac8022bcec20472edb43"
    sha256 cellar: :any,                 arm64_sonoma:  "efe286db670277512063d4cde57c5e363fdb2628f98cac8022bcec20472edb43"
    sha256 cellar: :any,                 sonoma:        "954c45bac365dda400b9f5cc24e5b4d7bccf8f08744738146e437a0e7eea4d2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "517ba4f0a6867edc0dae5e48da0e6a3c2267f0e98ec3153eab3db3c765e10970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7115b82e5f595529052b1bc285d2e65bb1a70e6be40f5cb30abf367ca83f70d4"
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