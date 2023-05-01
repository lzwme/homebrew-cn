require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.10.2.tgz"
  sha256 "e9fbeaeaa2433a892939b167757c130d0c9ce936765bec70c2c42f9a74b8337f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "585113579dcdb1b76e84628c6c77fc9c1780baedee7f121f7cb53d8a2e67cb2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "585113579dcdb1b76e84628c6c77fc9c1780baedee7f121f7cb53d8a2e67cb2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "585113579dcdb1b76e84628c6c77fc9c1780baedee7f121f7cb53d8a2e67cb2b"
    sha256 cellar: :any_skip_relocation, ventura:        "7d7b8541f7c55089ca967696575bcf7a2adf751b6653eb867f55bf1213ad05d8"
    sha256 cellar: :any_skip_relocation, monterey:       "7d7b8541f7c55089ca967696575bcf7a2adf751b6653eb867f55bf1213ad05d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d7b8541f7c55089ca967696575bcf7a2adf751b6653eb867f55bf1213ad05d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "585113579dcdb1b76e84628c6c77fc9c1780baedee7f121f7cb53d8a2e67cb2b"
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