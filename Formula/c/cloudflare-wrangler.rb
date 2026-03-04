class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.70.0.tgz"
  sha256 "883975d874e06344e7978a33d371cf9c3a051394e5a617abef0fca755524e024"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8210f7c59f902d1355e25c2101451c2aa0324d0190c5e1f4451379b3da2aed7f"
    sha256 cellar: :any,                 arm64_sequoia: "21046a5fc78fa30a55f43446ea9f154295040a2d2f53ea965fee900bfc420833"
    sha256 cellar: :any,                 arm64_sonoma:  "21046a5fc78fa30a55f43446ea9f154295040a2d2f53ea965fee900bfc420833"
    sha256 cellar: :any,                 sonoma:        "23ed9b83f7a681dd2779564346dbb32cf317813fe2fe9db250e09677d7e7642e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "460524b0d9dc9e5e491f27f921d60b33a140ab4b66c844ff5d85f351fd2bce85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41e5fe37025562b7bb4852cc59c80a286b9e3c4a5106a26e77507bcc0943505b"
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