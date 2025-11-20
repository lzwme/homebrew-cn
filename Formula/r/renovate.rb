class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.17.0.tgz"
  sha256 "dc2a0e8afd9cfb20f6bffb52d9a797e7ee001cb297253577b2d05d5f9080c602"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1636238e8587fa75a66a2f666ca59971a08f4755348a703f4c40085e84419d11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f34d76a51ed29266c03f56d57701fb7530f9f39eaeff3114b9e7b66d293c664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05f75d288170261fe401944b3eccd71d32d207d7f8eba66cb1398a8318ec8228"
    sha256 cellar: :any_skip_relocation, sonoma:        "1457bb93c7696a9417bce624a9e814e14a43dd8d80e56332112f5a64e53da024"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88cdfc7c66881a534263f9af81cb10f728ff78e2e62e111345fa5fadad11a6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fff1bef0aee053a7e2bd80cb1dc762981f7db674aa052c56ce59e14fd39db55c"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end