class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.81.0.tgz"
  sha256 "ceca83e1898ea860c96fc7a3048508bef6786dfaa8971ff6ef5a457ef88ecb0f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed7c0fc63b9622b0e30f7525981399fbd6cbb9ca63d787396c8fecbe6de5df15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8ae8a3d5097167f1dd3250cf36456c3661b4ac1cf6f9015c9eaccd0edd0a31f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "117751f5f29105c4ddc0ff79cc3ad902435e02c231321a277a32864cd35c8d5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "26082574b5398838e37e991d92107d504f7b6a845a631418e562f9e7bd582d20"
    sha256 cellar: :any_skip_relocation, ventura:       "48832711b52ca2188f54db774fa9ff5243044e85c6d34c44481398c29455466b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1fa10bd2a88d3e4fea6a5d9a8bc10e8088e01928e2775c5a027d20e470b02e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73cbfc763d826a3cf0925f5d28ec5cd44abd0b47e29c3a838f7a783c1876a78"
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