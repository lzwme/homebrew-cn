require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.333.0.tgz"
  sha256 "17ab619ea8b57624be47ba6881e78cc3e6c132ddd04fcbdec81f647ef3e2d2ab"
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
    sha256                               arm64_sonoma:   "4bcc5278868bcbc88f1252229ae60d3e2c1aa6fd019302bc9f00318e8490611d"
    sha256                               arm64_ventura:  "708cd39e2de587229d1b0b59ba9ebf8699ac726e74440e74c3d72445bdf98f46"
    sha256                               arm64_monterey: "6953ac4a45cb60dee1e2c85b5a55aed3704361c13834829755232fd0cfc933c9"
    sha256                               sonoma:         "dcd07b04bf4b6be5886c81188e7b76d592451b136c8e5cc7c8642c338ab5057d"
    sha256                               ventura:        "5f40823f174fcd3854046db91772933f6c3ec64f04e0375fcd27b521df02a328"
    sha256                               monterey:       "c31982991cc985d3ce99e4c6f9e7a167f1470e72245792af8cefc19060d7c7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "042d45819c55670287afa306fdffffa197be82d70b2f4e993f2b7a9a943e3a94"
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