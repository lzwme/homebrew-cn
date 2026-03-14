class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.18.2.tgz"
  sha256 "32f576b5a890c0a16dd3975904dd91e51b496265dfd29321d058d0dc75a74263"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c568a63021d01bc885a5fe6f2618390a1342702cc0f9064fe775133a90a80693"
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