class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.3.tgz"
  sha256 "06110d844e2edda22759587bdd1a2b96a7b3c3f59cde11200dfc0f6514e97244"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf5021712d877ca54016549032745d70d3581b0ec268bf535bf13f977792a3dd"
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