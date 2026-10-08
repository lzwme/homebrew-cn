class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.7.1.tgz"
  sha256 "00a812f4b0d2559e54e655a97aae80a5b24acd0cf9db2177ec9942abb611058d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "154c4da0544c12ce380923561b4c6a13116dbc4637f5a228c1fe8b3c230eb099"
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