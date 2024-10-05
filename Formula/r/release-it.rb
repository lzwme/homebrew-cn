class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https:github.comrelease-itrelease-it"
  url "https:registry.npmjs.orgrelease-it-release-it-17.7.0.tgz"
  sha256 "ab8140efdaad434519f8a1d7e23b277a0079ff00ae67a195ebe0c7b49b5113c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f740226773f63def64b56ccf89d6da8a7256f808bffd86d1155e314ba9f8694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f740226773f63def64b56ccf89d6da8a7256f808bffd86d1155e314ba9f8694"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f740226773f63def64b56ccf89d6da8a7256f808bffd86d1155e314ba9f8694"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c07cb8c795b12a5424bf5c26029ba5ae99f6c5da967d33b8bef7ba40067a936"
    sha256 cellar: :any_skip_relocation, ventura:       "0c07cb8c795b12a5424bf5c26029ba5ae99f6c5da967d33b8bef7ba40067a936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f740226773f63def64b56ccf89d6da8a7256f808bffd86d1155e314ba9f8694"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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