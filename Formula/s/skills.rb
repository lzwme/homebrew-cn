class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.4.4.tgz"
  sha256 "7dd99b4ad5fce1dfc067c440cd9af051f70a6a26156e133f28b7818a39b01563"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2ebd300e6a3107dde486a8cf79dd707710b6a4f28b4846162cadb83bce39a15"
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