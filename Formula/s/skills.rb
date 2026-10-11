class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.7.2.tgz"
  sha256 "e269699f1a9d06d3768cbf97d979c53e2d6e3ca1f98fc2ae1bfaf9cceeb1b617"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e9ef18a420adcf6e08f6f943c24e97ff4d2f593d8e98562bf1284d06578c86f"
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