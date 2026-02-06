class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.63.0.tgz"
  sha256 "9388885327ecc4f439a87fc2116c2e3574f6069555cf9df69bb3bc0c45ae29b4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a3867d68c07ae278f3f628b3bad0b360696f920aed1cc476c68ac21f0a037342"
    sha256 cellar: :any,                 arm64_sequoia: "7a0870651793b31b813c3bd3e4f658f71e1432305e58d8f52ce69ee284a9f1b1"
    sha256 cellar: :any,                 arm64_sonoma:  "7a0870651793b31b813c3bd3e4f658f71e1432305e58d8f52ce69ee284a9f1b1"
    sha256 cellar: :any,                 sonoma:        "61f073d01040b935ae828b57d90eba6374c49fcabc1d6a1a41057f579156b227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6c385734a0e2993709fe2fbf4739d75f8a8a73a9849be818ca26a8ae137fd8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc765c3b30d7f666a16b3b3dcc4bd66f7aa13ca620f2971adfca4eaffe20b941"
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