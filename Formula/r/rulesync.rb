class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.1.1.tgz"
  sha256 "cc9fdce258943c85de01124b449b9fe58c661c5d4e7422dfa080e8eba1bd5f0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4717e81b26dfb578d514d835cd48e2c08a16037f0ac3096547e6d77a2a40c1c2"
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