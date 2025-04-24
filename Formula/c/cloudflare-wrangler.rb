class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.13.0.tgz"
  sha256 "0a6f12b158ba329f1f7129b5c1504eb76e9ff4adfdfd4aae253569352e9f8abd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "757e07efa7d36c95dddc01ac1992ec188ee71434d3ab8430f6f2480df623ab87"
    sha256 cellar: :any,                 arm64_sonoma:  "757e07efa7d36c95dddc01ac1992ec188ee71434d3ab8430f6f2480df623ab87"
    sha256 cellar: :any,                 arm64_ventura: "757e07efa7d36c95dddc01ac1992ec188ee71434d3ab8430f6f2480df623ab87"
    sha256                               sonoma:        "86189a7dd910e3a221dcc860ecd80c708315ed0332dde93d42c9a393901f29c4"
    sha256                               ventura:       "86189a7dd910e3a221dcc860ecd80c708315ed0332dde93d42c9a393901f29c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc7c00eae8b072125224772a724a0be7d015358b30683d50178e7ed0bd3f0864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bc60b4b934f2a65a111e99a4a3d1abb5938d5e29580ac906643696c5c86fd1"
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