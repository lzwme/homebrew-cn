class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.31.0.tgz"
  sha256 "d35e09a09a68db42316b298ff3206442a98efd95faadef98c8f144f3e5cd46e1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "acda5bb6da415d73e6b78021dcae095941e1df1f47fa65621ba17c39c29ece48"
    sha256                               arm64_sequoia: "acda5bb6da415d73e6b78021dcae095941e1df1f47fa65621ba17c39c29ece48"
    sha256                               arm64_sonoma:  "acda5bb6da415d73e6b78021dcae095941e1df1f47fa65621ba17c39c29ece48"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4b5fe987fb29d4b4100d4727c8cff3a921aa9cc8f71f28fd943c195970931b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "347cdaa640baad3e59d5409d0786ca35dbab5f2782ed523eabebff4a0f2f3d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeb42ff5f66d50e29d8583a64c0dc00b54a9d4cba87f589e658bd8616e2cc075"
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