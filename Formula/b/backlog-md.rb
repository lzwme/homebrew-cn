class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.35.3.tgz"
  sha256 "823dd51bf80d09236a326975469e6c77fcae50cc59b693757e47e6b89d931494"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b3723d909aed83958078325f777a2a7d4f84101bd7c072cb109a6e2e1786ead8"
    sha256                               arm64_sequoia: "b3723d909aed83958078325f777a2a7d4f84101bd7c072cb109a6e2e1786ead8"
    sha256                               arm64_sonoma:  "b3723d909aed83958078325f777a2a7d4f84101bd7c072cb109a6e2e1786ead8"
    sha256 cellar: :any_skip_relocation, sonoma:        "15770c2f41503e33a42cef0b692b8128a805dc1c26521fb85dc04a9d569e1014"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d9898f60e4d8753024c0a42225bfc86b8e42206ef0956fff120536e3eacb93a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "523b6a4ac5fe798fc48e22a89eb98905925a64ae3c1c75d167cdef2df810dd69"
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