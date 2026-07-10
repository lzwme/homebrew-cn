class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.4.0.tgz"
  sha256 "1b0dde4c274426e5b3e9ef58fb788f877d969d22c60831e10aaa298dbf3fa6ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "64c98e7f5fc33ef965205f31822ad727abe7eec351f369621364525e4c321f00"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end