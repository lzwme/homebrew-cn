require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1267.0.tgz"
  sha256 "27cfb88c204ac5387deeb7a034c349152767a0d8bc7f0d8d1ef4cf84f6e854c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ae64fdb6795f413c3063ed95213bc59b037f12e8d062f6e9435e040ea9ecf8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc64430704b582725d86db014ce814b7451652daa9771654ca46a156cdb68e6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a58e73d97e9f5ace8c98f890ef6727f183d8919c0857712e07b20a8a0d31878"
    sha256 cellar: :any_skip_relocation, sonoma:         "6753045e1546390cb461623139624fe69ce401f46088c508abf92fc782ce14c9"
    sha256 cellar: :any_skip_relocation, ventura:        "5c4bfcf5ff5dd5082a375a7bbbf00d6579b8f74ef88d0f3e6ce7a9cab669ac05"
    sha256 cellar: :any_skip_relocation, monterey:       "1eba89db007a1f5df076b4088c188275f81e16bd32884874577665969dbcb36a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "861dd815bd29974aae9c59c953a43d7528c68c0e66344c4d034276b1d9ec75ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end