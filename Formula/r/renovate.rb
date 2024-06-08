require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.399.0.tgz"
  sha256 "de460e53ec92cf6380e9f9a511d51383bedba76493744b119e1b48c9ef6427ea"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99e6115a5630c42acd7fef199e5519f8ca2c6a52c59b560d5f03f5acfa5dece1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12a20eaec5a556257e8616aa351a0604f8446b6cc67ae11bce8a7e7b4ca8e21a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f4ba67b7d7d8d0744df8e2dd42efa3c7b92dbf3a1c8cffc4e42017f88499caa"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ab5403fbe80c565e355bfbae24684038da2a71d1bc4ccf1036b6e2703a70bf3"
    sha256 cellar: :any_skip_relocation, ventura:        "a854946b1d1c526a6792b4339c7afa57a20a2431d211c0d59ba10357a8cd8a10"
    sha256 cellar: :any_skip_relocation, monterey:       "a7ddaf867fb61c77c6002bfb186ede8decd986b229960ee40be33bbd09e4e55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24eb5e255933a80bf1b8313117e466a1992b7599526d20ae689190f53549be5b"
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