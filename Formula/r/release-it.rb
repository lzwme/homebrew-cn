require "languagenode"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https:github.comrelease-itrelease-it"
  url "https:registry.npmjs.orgrelease-it-release-it-17.0.3.tgz"
  sha256 "99851b1266813967a0f89a5d50758c31d70048a0f6693b404f31491efa9a643d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3edbd465abbb6e7dd02edd4ae82e1e8936366f069bb5466a1d2558d48f72fdf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3edbd465abbb6e7dd02edd4ae82e1e8936366f069bb5466a1d2558d48f72fdf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3edbd465abbb6e7dd02edd4ae82e1e8936366f069bb5466a1d2558d48f72fdf7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c3b3d06960cf9cac755c81014fba89b818bb17b9c74c5f3bd58d7dd27d7cfe2"
    sha256 cellar: :any_skip_relocation, ventura:        "0c3b3d06960cf9cac755c81014fba89b818bb17b9c74c5f3bd58d7dd27d7cfe2"
    sha256 cellar: :any_skip_relocation, monterey:       "0c3b3d06960cf9cac755c81014fba89b818bb17b9c74c5f3bd58d7dd27d7cfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3edbd465abbb6e7dd02edd4ae82e1e8936366f069bb5466a1d2558d48f72fdf7"
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