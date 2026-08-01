class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.21.tgz"
  sha256 "10a7008ca357242001d765eba31b232de7b0897d9796b21fa0a76ab17729f9b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d04553ea031523692962c7278d7d6a3f7b34da9f47169c960ae55191666c33bf"
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