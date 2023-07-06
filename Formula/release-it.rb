require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-16.0.0.tgz"
  sha256 "30c698b38a69b32aa4fac30db40e5dfd0f374bf66ce9ce723215807f9a8c5378"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "154f7a88efbd6a6cba20ba5604b39316484364a1a8ab7eab9dca952ada126276"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "154f7a88efbd6a6cba20ba5604b39316484364a1a8ab7eab9dca952ada126276"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "154f7a88efbd6a6cba20ba5604b39316484364a1a8ab7eab9dca952ada126276"
    sha256 cellar: :any_skip_relocation, ventura:        "049260b7e864d86b8b1c34327227c2affdb4755062f55e893a4f5a9a79f5feac"
    sha256 cellar: :any_skip_relocation, monterey:       "049260b7e864d86b8b1c34327227c2affdb4755062f55e893a4f5a9a79f5feac"
    sha256 cellar: :any_skip_relocation, big_sur:        "049260b7e864d86b8b1c34327227c2affdb4755062f55e893a4f5a9a79f5feac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "154f7a88efbd6a6cba20ba5604b39316484364a1a8ab7eab9dca952ada126276"
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