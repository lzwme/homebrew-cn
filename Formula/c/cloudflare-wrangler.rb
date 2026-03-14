class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.73.0.tgz"
  sha256 "e52de9137205aa76cc2462d55c5e033c9e7eb0ee869a4f61d240327e679fb02e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a24a5ed5853931ed98576610c592ebbd9250597e4013b5eea3463e87e50f75d9"
    sha256 cellar: :any,                 arm64_sequoia: "897ccff5c06894d8767647c4580fe3cb7cb0d833a5a42e0ac3c1177ac82e62cf"
    sha256 cellar: :any,                 arm64_sonoma:  "897ccff5c06894d8767647c4580fe3cb7cb0d833a5a42e0ac3c1177ac82e62cf"
    sha256 cellar: :any,                 sonoma:        "fccefaac95cf33014af3b68d3ea599ca7efd787a0855e8f7632f3d73179e4821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "829cb492f1b937a45e89332d40a02332d069ebc29069105ae7d653b812a53d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed9e79e7683a16c139fc850b473ec257801fd53f7b0a2d1261402208c768f4f4"
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