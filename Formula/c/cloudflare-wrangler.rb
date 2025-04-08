class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.8.0.tgz"
  sha256 "c0b15ed9ca392706e208551a38c635021dc3244b8287a4127d6a18436e0357be"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "450850dda5dbdb0826f0bc28ad333da84ff9b9187be6a56079656778d6ff3565"
    sha256 cellar: :any,                 arm64_sonoma:  "450850dda5dbdb0826f0bc28ad333da84ff9b9187be6a56079656778d6ff3565"
    sha256 cellar: :any,                 arm64_ventura: "450850dda5dbdb0826f0bc28ad333da84ff9b9187be6a56079656778d6ff3565"
    sha256                               sonoma:        "c230832165ee5a2f0538b5be1e012e3552ce77cbe8920934d2e4965b0fb7ad84"
    sha256                               ventura:       "c230832165ee5a2f0538b5be1e012e3552ce77cbe8920934d2e4965b0fb7ad84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5746ce16de4c446406eccd6ee456c690957f37bf6676291d7cd00b612bd303c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f992e0e6d3fb9b40cef8eb2b5a2646ab2bc9577b884938ec01dfa9824c3fe0fb"
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