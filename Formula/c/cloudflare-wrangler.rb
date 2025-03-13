class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.114.1.tgz"
  sha256 "c75de0f09c8ce8e4a4c7d4fedebafb708208847cde8901dd89d886fb6c3a3daf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f95f693d40340a605ec626717430dc6433386aec1d8f12c8f3e27f78274158c6"
    sha256 cellar: :any,                 arm64_sonoma:  "f95f693d40340a605ec626717430dc6433386aec1d8f12c8f3e27f78274158c6"
    sha256 cellar: :any,                 arm64_ventura: "f95f693d40340a605ec626717430dc6433386aec1d8f12c8f3e27f78274158c6"
    sha256                               sonoma:        "0bc19079f81c1b2dcb306600e43f8bf4ee9d492c0631cee8f9e63b26f16d500b"
    sha256                               ventura:       "0bc19079f81c1b2dcb306600e43f8bf4ee9d492c0631cee8f9e63b26f16d500b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf7dd52fc5974f0d58c39114d700997278b03d3664ce1bc5be25bf655812635"
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