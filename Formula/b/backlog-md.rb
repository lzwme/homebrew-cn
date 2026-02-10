class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.35.6.tgz"
  sha256 "56d01b11e4dc149d0efc1a35721d0a21debe341fd5be431ea63452ab2530cc35"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7b3c4d9430df35fa1f4c95715cb64e8650c4ab4d22d69954075e4158093227a5"
    sha256                               arm64_sequoia: "7b3c4d9430df35fa1f4c95715cb64e8650c4ab4d22d69954075e4158093227a5"
    sha256                               arm64_sonoma:  "7b3c4d9430df35fa1f4c95715cb64e8650c4ab4d22d69954075e4158093227a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "62d9b4274818a9f2f79a5ace8112eaee5b3304e20ec26baf3aebd915de3f4b41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cb9584e985981a4771251bee8bb82c5b967518a2dd2623b2d29130c7fa728b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d6ba09c52be26cb27769e775464ed68fc56f1ad2360f6d7e0dd221849713d1f"
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