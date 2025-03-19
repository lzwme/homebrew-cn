class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.1.0.tgz"
  sha256 "817f3a60300264b226d948ac7285c6a10e9f518d0d011af36e55dc374f811152"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0c6703f19a9eb6bd4b1229b8aa2b460c9772caa8f4cb7ea2b0973508fe23aff"
    sha256 cellar: :any,                 arm64_sonoma:  "b0c6703f19a9eb6bd4b1229b8aa2b460c9772caa8f4cb7ea2b0973508fe23aff"
    sha256 cellar: :any,                 arm64_ventura: "b0c6703f19a9eb6bd4b1229b8aa2b460c9772caa8f4cb7ea2b0973508fe23aff"
    sha256                               sonoma:        "36b67b48f6d9b90bc7cf61ef7847bba0afa0f1392a815edd89daad220e5dacc1"
    sha256                               ventura:       "36b67b48f6d9b90bc7cf61ef7847bba0afa0f1392a815edd89daad220e5dacc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d32154d26ed21d64f35c6da1e185af9f4fcf668d5346d861d3bb87d81fbd07c"
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