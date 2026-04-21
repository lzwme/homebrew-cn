class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.4.0.tgz"
  sha256 "4e4d14dade00f1116080c5c7e56549aeef26d2ac6a5d7baff87e7a03f60e53e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cc4c1fdf818de5641e4d25455e90811463b6d0b6b06c0ee9d8747928c0c44e85"
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