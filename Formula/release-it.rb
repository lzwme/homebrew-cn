require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.6.1.tgz"
  sha256 "170b8df12e6377947c58be3a88cbfe600ef403557baabad2f50f8786b499d00d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb5b80f00182230b4fae5330311b2781dd16c90b103cc07a53edf63f99f4f85a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb5b80f00182230b4fae5330311b2781dd16c90b103cc07a53edf63f99f4f85a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb5b80f00182230b4fae5330311b2781dd16c90b103cc07a53edf63f99f4f85a"
    sha256 cellar: :any_skip_relocation, ventura:        "457be50fe3e5f714b4b52bc12edd49ccc89bf3668b173ec7b5010405d56c7f69"
    sha256 cellar: :any_skip_relocation, monterey:       "457be50fe3e5f714b4b52bc12edd49ccc89bf3668b173ec7b5010405d56c7f69"
    sha256 cellar: :any_skip_relocation, big_sur:        "457be50fe3e5f714b4b52bc12edd49ccc89bf3668b173ec7b5010405d56c7f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5b80f00182230b4fae5330311b2781dd16c90b103cc07a53edf63f99f4f85a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/release-it -v")
    (testpath/"package.json").write("{\"name\":\"test-pkg\",\"version\":\"1.0.0\"}")
    assert_match(/Let's release test-pkg.+\(1\.0\.0\.\.\.1\.0\.1\).+Empty changelog.+Done \(in \d+s\.\)/m,
      shell_output("#{bin}/release-it --npm.skipChecks --no-npm.publish --ci"))
    assert_match "1.0.1", (testpath/"package.json").read
  end
end