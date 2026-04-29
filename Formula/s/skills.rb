class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.2.tgz"
  sha256 "c724b8a60a30dee2dd4a76dfb71117051ac06daf4ed9527af9ed25b13d93927e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72f6ce23a1de2272dee1e8ecb98b99c6c03372fddbfa822f5d2300194fd5b311"
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