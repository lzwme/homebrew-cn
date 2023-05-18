require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.93.0.tgz"
  sha256 "e977d771cba2354878ae54ade525a7b28872086e2d30c2a89eed372288625dfa"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256                               arm64_ventura:  "60e02760a2d6c67af32d3c2b3cf17f8753ba27bca01063f5eda360cc7897519f"
    sha256                               arm64_monterey: "d1cbc4c5afd333207a0de1eb0d7c6237b63ce8bf956aa5b842b6dcf9512f003e"
    sha256                               arm64_big_sur:  "7fb699ba88a981582300a4c47d0a049bdfc57557aa0105f3668bb339453bf85e"
    sha256                               ventura:        "c49fbeb1da3529693b5bee6c73e15c84d28b06c3e100f8e40967c9fa1da4b385"
    sha256                               monterey:       "4f48ac59521781266e1898ca4422f929109eaa1a013e1294659a3ca6b63e6d11"
    sha256                               big_sur:        "b07f571ec853c2c478a0de47f4d5be8da1f88572ee50bb73fadaa3eaf477c91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bd1d8a9c5e2e08ae34f5ef4015d980ef49a8a57ec60b10a1c7a08f5813f9ab1"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end