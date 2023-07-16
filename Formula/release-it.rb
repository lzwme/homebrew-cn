require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-16.1.2.tgz"
  sha256 "c4aede7c2567e3a32d02418a44c443c7d7d3482e2efc27ee50cb60255e096d48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c504fb16a2ad5b0bb659d06e080ebb2affd2810a89834eddd627d5b77d974fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c504fb16a2ad5b0bb659d06e080ebb2affd2810a89834eddd627d5b77d974fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c504fb16a2ad5b0bb659d06e080ebb2affd2810a89834eddd627d5b77d974fe"
    sha256 cellar: :any_skip_relocation, ventura:        "5d0b7bba9d3d8de7bd4d7d453a5cad85614648e3c4a59b8e5539dd19d24694a3"
    sha256 cellar: :any_skip_relocation, monterey:       "5d0b7bba9d3d8de7bd4d7d453a5cad85614648e3c4a59b8e5539dd19d24694a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d0b7bba9d3d8de7bd4d7d453a5cad85614648e3c4a59b8e5539dd19d24694a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c504fb16a2ad5b0bb659d06e080ebb2affd2810a89834eddd627d5b77d974fe"
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