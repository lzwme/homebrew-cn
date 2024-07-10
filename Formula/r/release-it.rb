require "languagenode"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https:github.comrelease-itrelease-it"
  url "https:registry.npmjs.orgrelease-it-release-it-17.5.0.tgz"
  sha256 "52651ee3df18c94e406428abc92149d657eddbf19f7b266382fbab4529bd5afe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "041711cdf9911a4e02edbd9067084a5e7787f416d48ce8b5af4af97129912395"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "041711cdf9911a4e02edbd9067084a5e7787f416d48ce8b5af4af97129912395"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "041711cdf9911a4e02edbd9067084a5e7787f416d48ce8b5af4af97129912395"
    sha256 cellar: :any_skip_relocation, sonoma:         "d79a699bda619b1a8aab370adbd1f9abf96200e291b0104aa80509e6737f7651"
    sha256 cellar: :any_skip_relocation, ventura:        "d79a699bda619b1a8aab370adbd1f9abf96200e291b0104aa80509e6737f7651"
    sha256 cellar: :any_skip_relocation, monterey:       "d79a699bda619b1a8aab370adbd1f9abf96200e291b0104aa80509e6737f7651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c7abe24d504a3b93cce391b3229d01d2cb88dfd8e646b10ce21a64fb703f0fe"
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