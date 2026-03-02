class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.4.3.tgz"
  sha256 "fea8ad6c568912be00fd55d454dc7b0898daa3ee1e2744527e01b42a9c6cafe6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b403a326f65ce947ef879e21e8ed446ccdeeb50536f740c3003feb499be3642"
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