class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-14.2.0.tgz"
  sha256 "cb6766e6498a3db7af86d09870ea02a792cd35cface1c69862c3316899023e8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba89519c3bbabb976c21d70707cace994cb7a93be7496f4d28636683b762b419"
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