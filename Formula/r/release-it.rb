class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https:github.comrelease-itrelease-it"
  url "https:registry.npmjs.orgrelease-it-release-it-18.0.0.tgz"
  sha256 "eb2af1b1754ea5bbfc90450129f226e20d81d98eff006563206f841cd69559b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70540cea9812493d56998f9c0870bdea1ee6061c2a47c46322aa4cf763be9c07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70540cea9812493d56998f9c0870bdea1ee6061c2a47c46322aa4cf763be9c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70540cea9812493d56998f9c0870bdea1ee6061c2a47c46322aa4cf763be9c07"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3714a7dda8ead35f87962f7c37185047fafff4a54db643eb65d4fbad50fa574"
    sha256 cellar: :any_skip_relocation, ventura:       "f3714a7dda8ead35f87962f7c37185047fafff4a54db643eb65d4fbad50fa574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70540cea9812493d56998f9c0870bdea1ee6061c2a47c46322aa4cf763be9c07"
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