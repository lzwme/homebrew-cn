require "languagenode"

class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https:retirejs.github.ioretire.js"
  url "https:registry.npmjs.orgretire-retire-5.1.2.tgz"
  sha256 "363f3827a82a5e482d2e9bdc4a6b21a9d833e87e991142a778b758643498cfbc"
  license "Apache-2.0"
  head "https:github.comRetireJSretire.js.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d32874a2bd665a2a044bdcf7113b3a658c26dd355e252c96def57af882d3ba7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d32874a2bd665a2a044bdcf7113b3a658c26dd355e252c96def57af882d3ba7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d32874a2bd665a2a044bdcf7113b3a658c26dd355e252c96def57af882d3ba7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d32874a2bd665a2a044bdcf7113b3a658c26dd355e252c96def57af882d3ba7c"
    sha256 cellar: :any_skip_relocation, ventura:        "d32874a2bd665a2a044bdcf7113b3a658c26dd355e252c96def57af882d3ba7c"
    sha256 cellar: :any_skip_relocation, monterey:       "d32874a2bd665a2a044bdcf7113b3a658c26dd355e252c96def57af882d3ba7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f23ba8222f182a9d7c07cc1dffae8f4c5e6923710b786c3f4548812f6af84f52"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}retire --version")

    system "git", "clone", "https:github.comappseccodvna.git"
    output = shell_output("#{bin}retire --path dvna 2>&1", 13)
    assert_match(jquery (\d+(?:\.\d+)+) has known vulnerabilities, output)
  end
end