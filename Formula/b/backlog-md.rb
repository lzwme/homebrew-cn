class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.47.0.tgz"
  sha256 "830c422222471c3a0368d276debeed9d3dcc76c7e0de782336042a42e667bab0"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a686f1156b394afe7f4cea9e50f9535cb4b95a5878775dbf39d80f5a42a8a618"
    sha256                               arm64_sequoia: "a686f1156b394afe7f4cea9e50f9535cb4b95a5878775dbf39d80f5a42a8a618"
    sha256                               arm64_sonoma:  "a686f1156b394afe7f4cea9e50f9535cb4b95a5878775dbf39d80f5a42a8a618"
    sha256 cellar: :any_skip_relocation, sonoma:        "11bbac5bba8cb96d769a4cb876347b79898dec2a4bcec3e74c45d9ba12c2eaee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd816f91ae2f5dfc708c81e3651a09aa8e3425c42fa12fd7ad8068ae366dfff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32539ff99d422d38929bd1e1e8932dba11d484cb307c9b2790399830c22f725c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end