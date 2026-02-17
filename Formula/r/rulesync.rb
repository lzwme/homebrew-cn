class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.3.0.tgz"
  sha256 "2053d54e2fa5480b4d6ad792a12c471c1ff0c69ce9dc26cfa628cfc89c54a754"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2c5534439015772a3c2d36c7f2b6b4e298fab123212a29bedce461ff690cb31"
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