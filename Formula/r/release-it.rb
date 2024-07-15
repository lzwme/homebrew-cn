require "languagenode"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https:github.comrelease-itrelease-it"
  url "https:registry.npmjs.orgrelease-it-release-it-17.6.0.tgz"
  sha256 "bcdd80d759a96b8dbca3d662b5b33c3615fc82284412b6f23554e248250d1be5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51e149180106cbde7372b92c21c88d1db89b76f2fb607cb3ab650f1fa10f040a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51e149180106cbde7372b92c21c88d1db89b76f2fb607cb3ab650f1fa10f040a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51e149180106cbde7372b92c21c88d1db89b76f2fb607cb3ab650f1fa10f040a"
    sha256 cellar: :any_skip_relocation, sonoma:         "80912520bad19c624f4bbe4db2ef3327f72686d2948f08e1378db101efc69792"
    sha256 cellar: :any_skip_relocation, ventura:        "80912520bad19c624f4bbe4db2ef3327f72686d2948f08e1378db101efc69792"
    sha256 cellar: :any_skip_relocation, monterey:       "43a9f66ddd9840daee8b2315825bae68a2bb8adf9fd45bbf01f53b8feca06627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be30ea7906202453673ec62344e941922562c95ecfee9ae5c53c993a2c39a80e"
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