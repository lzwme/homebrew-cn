require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.363.0.tgz"
  sha256 "7a7a315a86062ee79eb74876f0ab99ea633ffd8a19f7f166d8c78c507c52270f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4c93d60c4d9df5028b5f8528128272d871968e057af80c9c1534d22982ba20e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1a6b39cfa2abd17cfe406d0d1b861426f1294f0919bc8edf40d1d3434be43b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeb3b262300246c452becf83f282cd25cb9378655e9f1d2e41bea1bbaa641546"
    sha256                               sonoma:         "30f8a6262d5dce25a74654342e77af03a2ba8654358e434af9fa5a5992614a0b"
    sha256                               ventura:        "c20319633b1b58a66a36cf8c289c54aacf1f70324dc5244afd96909810d1f87b"
    sha256                               monterey:       "3192709112d4c3f45c59b205b13a4151e2a37dbf058807a71203aef7cd235684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bafc62825d6419fb8c303231a4184e891ebbe63bc7319b087126c84252305d13"
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