class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.9.0.tgz"
  sha256 "fa32d718f8ac67a654933ce2eff41c38e113c8db8e45aa901cfa9115756f618c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c265d4284c8030b6211ade3d75d5a006e896c0f3ea70dc0f8b04ebcbd0e6e83"
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