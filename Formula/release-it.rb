require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.10.3.tgz"
  sha256 "fa300de186cbfc0c79d2ee4d5b5b07349b45fa7307ef8bac0904c9df99c73206"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13ce9917a18e28c185716478218a2747ae9a93c364cff588c602c3783f4e4672"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13ce9917a18e28c185716478218a2747ae9a93c364cff588c602c3783f4e4672"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13ce9917a18e28c185716478218a2747ae9a93c364cff588c602c3783f4e4672"
    sha256 cellar: :any_skip_relocation, ventura:        "57bf0756816c9e51afadf79da7489c734331acc9abb56e7231d8a39061de8d77"
    sha256 cellar: :any_skip_relocation, monterey:       "57bf0756816c9e51afadf79da7489c734331acc9abb56e7231d8a39061de8d77"
    sha256 cellar: :any_skip_relocation, big_sur:        "57bf0756816c9e51afadf79da7489c734331acc9abb56e7231d8a39061de8d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13ce9917a18e28c185716478218a2747ae9a93c364cff588c602c3783f4e4672"
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