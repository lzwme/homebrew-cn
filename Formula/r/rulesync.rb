class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.26.0.tgz"
  sha256 "94473e346d61cac57784f0e03165ee9efc073a86ad5bbf238db8fc340757a58b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58400f9dfc4d1ac186bcea61a712f0c9474ee3110a17f8771fdbfef724ff1f89"
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