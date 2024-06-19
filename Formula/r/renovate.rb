require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.412.0.tgz"
  sha256 "ae85c0dc3f6c16280087bd84d64d379ea37b12215d39ebfb54ad1807c8ed3a42"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85e4904141c6de75efa186590292cf65960a82d76440a9f9da594a4e30501f48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8f31593486c172a01270ef65ff4e8a9c700abcff9560b83f74773410e0968f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24e67123a995addf673fd3304d0750e6020d1fed5f61d9f84c16c0754373dbd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "06a54e553b4ec6144f404a8b335bdb434c682479874dcb03a77134bf78ac6325"
    sha256 cellar: :any_skip_relocation, ventura:        "09f978b7d6915908d3f2e20922a9019e4293a709fcd4f31f08da1e36673fd3e3"
    sha256 cellar: :any_skip_relocation, monterey:       "9d299ff8194e07ac7d80ae2f4bb393b868bf62f68d473db4d4244e98853ee194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd8c0fadff2930fc556aaa7b9092db7972d1385a12292d267f3aa566be74a994"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end