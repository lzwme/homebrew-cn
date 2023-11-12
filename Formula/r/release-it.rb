require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.0.0.tgz"
  sha256 "e3493b34980483972ddde2a3ca74fe41be83f1f056eb84316b07f9429ca908c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cf7f7b0bd828875f23f5081cafdacd01a314dfb31918bbebcbd7c04a2971423"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cf7f7b0bd828875f23f5081cafdacd01a314dfb31918bbebcbd7c04a2971423"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cf7f7b0bd828875f23f5081cafdacd01a314dfb31918bbebcbd7c04a2971423"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3b1ebcd972ae0c1495f57017132fec85e4feaf0586cbfdbd0cccb2022948ed7"
    sha256 cellar: :any_skip_relocation, ventura:        "c3b1ebcd972ae0c1495f57017132fec85e4feaf0586cbfdbd0cccb2022948ed7"
    sha256 cellar: :any_skip_relocation, monterey:       "c3b1ebcd972ae0c1495f57017132fec85e4feaf0586cbfdbd0cccb2022948ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf7f7b0bd828875f23f5081cafdacd01a314dfb31918bbebcbd7c04a2971423"
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