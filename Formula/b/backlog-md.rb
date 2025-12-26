class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.28.0.tgz"
  sha256 "df383f2ede30db0a4a38cbc8bd2279a4dc63dc917b03d922102fe762ce48c5ee"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0f8e04037468caa037336bfbe03b7ea38284aeec90b7e2587350937807bcb84d"
    sha256                               arm64_sequoia: "0f8e04037468caa037336bfbe03b7ea38284aeec90b7e2587350937807bcb84d"
    sha256                               arm64_sonoma:  "0f8e04037468caa037336bfbe03b7ea38284aeec90b7e2587350937807bcb84d"
    sha256 cellar: :any_skip_relocation, sonoma:        "46e4c2fee9663481a1067647aafb514dd08286953aae7a2c482889265ab88737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c38e22591d2d5a4b4c4ce6abb9a07e1f9dd05417a855b05660eff57f5fdd223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a2dc9b5f29bce2258e092bd5d9ff3c0ccb98901b81e2609dc2e50b086810b8c"
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