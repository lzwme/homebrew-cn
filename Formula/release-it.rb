require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-16.1.3.tgz"
  sha256 "44b32a46a22f6aa88f4a1e7fa453abfc5d1385ebada8bc198fae8e5dedd7d022"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "778a6a1795298f32190c2b3e5b283a190f5a8be90e0bc0effb4f91dcc7460f8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "778a6a1795298f32190c2b3e5b283a190f5a8be90e0bc0effb4f91dcc7460f8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "778a6a1795298f32190c2b3e5b283a190f5a8be90e0bc0effb4f91dcc7460f8e"
    sha256 cellar: :any_skip_relocation, ventura:        "ff9a98e65f810b45aadd29e12f100283def1721027090aaa44862308e29bfdd4"
    sha256 cellar: :any_skip_relocation, monterey:       "ff9a98e65f810b45aadd29e12f100283def1721027090aaa44862308e29bfdd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff9a98e65f810b45aadd29e12f100283def1721027090aaa44862308e29bfdd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe36f01be7cad900f9621582fcfe713f8763b808299329a2194caa1bce1b660"
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