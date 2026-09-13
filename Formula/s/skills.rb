class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.26.tgz"
  sha256 "bc93cd403104ab859abdfbe692ba1fb4429fd2e47c38abb27449a4e8e6ba943c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06a6941b9d2e14ff94590f735f0115ca1e7203c4e52d5ada8536e23c1bad47dd"
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