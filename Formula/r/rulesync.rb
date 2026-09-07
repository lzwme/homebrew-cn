class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.24.1.tgz"
  sha256 "0a4ce0b144b6403e2714ed94b44afd73ad35d94ae002929a7f8d4bbf31a22ae8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93ec90b33ea0597281306a63f5741e3ab74b0db1ec859d50616969b7b736ef5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93ec90b33ea0597281306a63f5741e3ab74b0db1ec859d50616969b7b736ef5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93ec90b33ea0597281306a63f5741e3ab74b0db1ec859d50616969b7b736ef5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c006f78785e58fcf0872ba1780a12b541554e3f143f77d864dc6d8e10bb306c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c006f78785e58fcf0872ba1780a12b541554e3f143f77d864dc6d8e10bb306c"
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