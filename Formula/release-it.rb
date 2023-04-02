require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.10.0.tgz"
  sha256 "2539992707cf02e4a82a23cd9f012befabe4c6464a7b7d8e0d4a1f536acbe4cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab2de4853a38535a44a25aef78568b652374dc4d528349f70d31fbd15419470b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab2de4853a38535a44a25aef78568b652374dc4d528349f70d31fbd15419470b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab2de4853a38535a44a25aef78568b652374dc4d528349f70d31fbd15419470b"
    sha256 cellar: :any_skip_relocation, ventura:        "7295aeb18107da1946c3f145d6703d5da2217854c4dab696bd6e924661fb0221"
    sha256 cellar: :any_skip_relocation, monterey:       "7295aeb18107da1946c3f145d6703d5da2217854c4dab696bd6e924661fb0221"
    sha256 cellar: :any_skip_relocation, big_sur:        "7295aeb18107da1946c3f145d6703d5da2217854c4dab696bd6e924661fb0221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab2de4853a38535a44a25aef78568b652374dc4d528349f70d31fbd15419470b"
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