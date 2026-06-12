class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.11.tgz"
  sha256 "e60e4b349fbabd7d18f42da3fdc5f9b4e19988adb3e39f6503da47fdb9ea2f14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24ce348432dea5e65fc999d958b5a6140d92263eece8386af5ca153b40a95429"
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