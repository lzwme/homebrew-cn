class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.24.tgz"
  sha256 "104d02a446f1defc46d67480b40d95f481725fc8b3a491d93b1f5c1a45daf960"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28ca449f299656e0933d9bbbfc3e92e7ea6a10f0fd258d3bef353d8c7ffc103d"
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