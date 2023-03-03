require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.7.0.tgz"
  sha256 "1c6b46b7a759ea2fa344ad3029997c13145606951c14646e395d3dc8619fb6be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba32a39824f3710a5b2246344f84c1f4b939d3c8f0156daa862402038002aa71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba32a39824f3710a5b2246344f84c1f4b939d3c8f0156daa862402038002aa71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba32a39824f3710a5b2246344f84c1f4b939d3c8f0156daa862402038002aa71"
    sha256 cellar: :any_skip_relocation, ventura:        "29d44b32e8128fcab1af12a8b1b77368081e253f98473222db23a3e72b6451b7"
    sha256 cellar: :any_skip_relocation, monterey:       "29d44b32e8128fcab1af12a8b1b77368081e253f98473222db23a3e72b6451b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "29d44b32e8128fcab1af12a8b1b77368081e253f98473222db23a3e72b6451b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba32a39824f3710a5b2246344f84c1f4b939d3c8f0156daa862402038002aa71"
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