class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.19.tgz"
  sha256 "28413d3fd1503d41f5a1796541197e94763d5f97b32db0ea556b64f6b293a68a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43306aacf3b819224c4a7c68d9107f77ddcae763eef71704caff36aa2eea45bb"
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