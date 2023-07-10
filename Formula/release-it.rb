require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-16.1.0.tgz"
  sha256 "1a3a6ce43efd587724e8ff7c5814d844e64ea7095c0e61de6bd135ef6b18eea3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fee3f7dd6b111957d490e06d4370499d2fb5fd5e3b62b9180dcd71d419aebb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fee3f7dd6b111957d490e06d4370499d2fb5fd5e3b62b9180dcd71d419aebb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fee3f7dd6b111957d490e06d4370499d2fb5fd5e3b62b9180dcd71d419aebb1"
    sha256 cellar: :any_skip_relocation, ventura:        "a0e5fb415bbfacf8244111a7202ec7b1932ceb3b59280f80cd1bcbd57f4cd90f"
    sha256 cellar: :any_skip_relocation, monterey:       "a0e5fb415bbfacf8244111a7202ec7b1932ceb3b59280f80cd1bcbd57f4cd90f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0e5fb415bbfacf8244111a7202ec7b1932ceb3b59280f80cd1bcbd57f4cd90f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fee3f7dd6b111957d490e06d4370499d2fb5fd5e3b62b9180dcd71d419aebb1"
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