require "languagenode"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https:github.comrelease-itrelease-it"
  url "https:registry.npmjs.orgrelease-it-release-it-17.4.0.tgz"
  sha256 "84221cfd1fdc097c0be6362f8bfc4b6cd2bb3e387f7105971900a5305f798060"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1fcfb1e98e3ebb4c81bbd163541dd2d1c17ba87bf321038e5efb71c9e7c28ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1fcfb1e98e3ebb4c81bbd163541dd2d1c17ba87bf321038e5efb71c9e7c28ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1fcfb1e98e3ebb4c81bbd163541dd2d1c17ba87bf321038e5efb71c9e7c28ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ee7811d7a1788c89a2f5489de91a8afb16f1eacd5677c7b77e4507a6bd60bce"
    sha256 cellar: :any_skip_relocation, ventura:        "3ee7811d7a1788c89a2f5489de91a8afb16f1eacd5677c7b77e4507a6bd60bce"
    sha256 cellar: :any_skip_relocation, monterey:       "3ee7811d7a1788c89a2f5489de91a8afb16f1eacd5677c7b77e4507a6bd60bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c65d75c2e0035ee89ebce86f1a5a0aade9b0fe7170415f1ba2a0c134bd90083"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}release-it -v")
    (testpath"package.json").write("{\"name\":\"test-pkg\",\"version\":\"1.0.0\"}")
    assert_match(Let's release test-pkg.+\(1\.0\.0\.\.\.1\.0\.1\).+Empty changelog.+Done \(in \d+s\.\)m,
      shell_output("#{bin}release-it --npm.skipChecks --no-npm.publish --ci"))
    assert_match "1.0.1", (testpath"package.json").read
  end
end