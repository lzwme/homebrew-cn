class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.15.1.tgz"
  sha256 "0d230e97d22ed21a05547e131ee81ebfd2f8e8c92d5daaf21d75921a32dbf098"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "456467907561372ebf397776a08dfaaac5e03e4b783abe143bf48c5aa7e3c212"
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