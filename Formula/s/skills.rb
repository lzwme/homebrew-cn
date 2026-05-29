class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.9.tgz"
  sha256 "6524602930bb18fe0e613033a84b3120217d9d66b14d27ece9b028ddb279417f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a214b9d8d5461735f6de1cfb9fe902205db93b414e1bc8f3b172053003acf178"
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