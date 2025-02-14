class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.109.0.tgz"
  sha256 "84249b36c43c9e29174d4f65b7a5f9bf06ba74dd470c34783a39aaffafc7bdd6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d45487b54c3d656e335ad6609b04be8957bbfdd94b4f34a35a231252bb353c88"
    sha256 cellar: :any,                 arm64_sonoma:  "d45487b54c3d656e335ad6609b04be8957bbfdd94b4f34a35a231252bb353c88"
    sha256 cellar: :any,                 arm64_ventura: "d45487b54c3d656e335ad6609b04be8957bbfdd94b4f34a35a231252bb353c88"
    sha256                               sonoma:        "c24a61ffb7c20776cc32f6370e41eddf188ca495b0714c58062f3da30e985e0f"
    sha256                               ventura:       "c24a61ffb7c20776cc32f6370e41eddf188ca495b0714c58062f3da30e985e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab3a8f6d777c5fc20e75caf72a612f555d191e50733c5377592b0dbeff6a99f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end