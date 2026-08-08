class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.22.tgz"
  sha256 "10cee39139debe6c0188f4727194ade59234b277ccca2320e3ed6b620ee7f14b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0547d264e2653705178edba2507ea79d1d05500e3859bd210481282d591ae40"
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