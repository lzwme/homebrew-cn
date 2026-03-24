class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.4.6.tgz"
  sha256 "d674c00176c70a437c9586d8f2ef7cf825b47bb1ad82bf505e2d9331052f3915"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6fba176358b5d09b9caf5fe46cdd36b2d5c16d2e093f598a5cff29c18633f58b"
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