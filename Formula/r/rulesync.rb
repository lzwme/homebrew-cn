class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.14.0.tgz"
  sha256 "cfb462b8370ea3573a70e62d792398aca8cdc94a2b11ab29b8821e9eee81e50e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b33b5fe94c279d1cd56685d165a9a4fc0319f8035de9476bda230e9ef15dada8"
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