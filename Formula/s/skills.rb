class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.16.tgz"
  sha256 "f7f0177345ed74c8a28990fde2c05a4e4967919fd264cc73bde5def9003ec2e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86c3cf74ae4067c4d73d0e2d8198865411cc5a3f1bb6d267a511f13d48ed2da5"
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