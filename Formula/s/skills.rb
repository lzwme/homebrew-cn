class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.17.tgz"
  sha256 "3a1e7b338fd2268a895fc100c7008fb28b4816d4d6c14c1404fd102a61c9a49c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c86b132e2f76eea953c0dc088a1b7c0bfd436b585e97ca0e3184b1eaccbdb5f"
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