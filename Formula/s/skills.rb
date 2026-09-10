class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.25.tgz"
  sha256 "5113db6c999c4c1ce2e63e5f5e96f1b4eec43843feb770d0d2bd95ef58c82203"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59c852ee5f1b373806814acaa0487237a107128d8a73459b45b308d2ae4e799c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skills --version")
    assert_match "No project skills found", shell_output("#{bin}/skills list")
    system bin/"skills", "init", "test-skill"
    assert_path_exists testpath/"test-skill/SKILL.md"
  end
end