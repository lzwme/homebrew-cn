require "languagenode"

class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https:retirejs.github.ioretire.js"
  url "https:registry.npmjs.orgretire-retire-5.0.0.tgz"
  sha256 "1489f86f9f0de387257c8250930be3ced3e2aa5e9f1dceabd4a924bf9ed9bf96"
  license "Apache-2.0"
  head "https:github.comRetireJSretire.js.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88b33ce8cb62690d38866f4fac985cff018fddaf845678e37dc9469b8f09c3af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88b33ce8cb62690d38866f4fac985cff018fddaf845678e37dc9469b8f09c3af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88b33ce8cb62690d38866f4fac985cff018fddaf845678e37dc9469b8f09c3af"
    sha256 cellar: :any_skip_relocation, sonoma:         "88b33ce8cb62690d38866f4fac985cff018fddaf845678e37dc9469b8f09c3af"
    sha256 cellar: :any_skip_relocation, ventura:        "88b33ce8cb62690d38866f4fac985cff018fddaf845678e37dc9469b8f09c3af"
    sha256 cellar: :any_skip_relocation, monterey:       "88b33ce8cb62690d38866f4fac985cff018fddaf845678e37dc9469b8f09c3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0aeaf97e01dc4d9ff71952b00619a728f2b0cfa08d8f7cc8ee4e36cb3a73ebf"
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