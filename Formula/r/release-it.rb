require "languagenode"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https:github.comrelease-itrelease-it"
  url "https:registry.npmjs.orgrelease-it-release-it-17.4.2.tgz"
  sha256 "4dde3ed255103a8b7afd885e47f9767fd4274ea7f53f9525f37f1b5d0dd96bb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5209d1094b0dc46e241bc3c06c25748a181bb000a9716d3db9c6dfdfb81e1f10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5209d1094b0dc46e241bc3c06c25748a181bb000a9716d3db9c6dfdfb81e1f10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5209d1094b0dc46e241bc3c06c25748a181bb000a9716d3db9c6dfdfb81e1f10"
    sha256 cellar: :any_skip_relocation, sonoma:         "652ff57f9f4129d5c6d88eeceb21eeb891c7603eb5301a0901ab28cc836a88e1"
    sha256 cellar: :any_skip_relocation, ventura:        "652ff57f9f4129d5c6d88eeceb21eeb891c7603eb5301a0901ab28cc836a88e1"
    sha256 cellar: :any_skip_relocation, monterey:       "652ff57f9f4129d5c6d88eeceb21eeb891c7603eb5301a0901ab28cc836a88e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83d8d60fbe16975193eed8e4c1576c0d7eb95778929185a458979e59e4568b2"
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