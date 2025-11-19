class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.49.0.tgz"
  sha256 "8607df3be61175fa7424e6a9adb109edd9eb245dd4e0c8f6bc4d8fd95252e3c4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bcbb55faef451b9611646184b15113c98fd130998688f719be7355e29380d21a"
    sha256 cellar: :any,                 arm64_sequoia: "2598f42dcfb5801ba43960f63c0364c3f1e3cd1fffa8726f4ab7bae80fe1703c"
    sha256 cellar: :any,                 arm64_sonoma:  "2598f42dcfb5801ba43960f63c0364c3f1e3cd1fffa8726f4ab7bae80fe1703c"
    sha256 cellar: :any,                 sonoma:        "29b282508f805102b747ab45bdd45aa701a4dbedf1ded875c53725563663976c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b25b87450f0b3a1d432e3448efcbb0c451a56596e2bd6e40c88570ed5a4f1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a88d6585af771e2d38d7b098998109ecddb3136064ad0eb6949b891c8d44ac8"
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