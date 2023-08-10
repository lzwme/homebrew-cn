require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-16.1.4.tgz"
  sha256 "5827af3ef920a2ab85ebb8bd3c5716e392cdf53cc0b9d57caf36d19d8478547c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb063fa9e20c049f7023ac7a8a77ad6e80cfd2b56b333781056e4a4c292c6bd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb063fa9e20c049f7023ac7a8a77ad6e80cfd2b56b333781056e4a4c292c6bd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb063fa9e20c049f7023ac7a8a77ad6e80cfd2b56b333781056e4a4c292c6bd8"
    sha256 cellar: :any_skip_relocation, ventura:        "8d2894b05ccad6e69937941a3ac55637e10d092655eb9e76a16e13b71116fef0"
    sha256 cellar: :any_skip_relocation, monterey:       "8d2894b05ccad6e69937941a3ac55637e10d092655eb9e76a16e13b71116fef0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d2894b05ccad6e69937941a3ac55637e10d092655eb9e76a16e13b71116fef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb063fa9e20c049f7023ac7a8a77ad6e80cfd2b56b333781056e4a4c292c6bd8"
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