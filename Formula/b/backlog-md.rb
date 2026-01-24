class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.35.4.tgz"
  sha256 "7f10e32a14b4ce4bb4aa7cdcb486419a177009c3b525c41f05abff03f74e915f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1719419ea9d3214c33fed7f7106e05801485b8b15d879e0560dc7179c42b7107"
    sha256                               arm64_sequoia: "1719419ea9d3214c33fed7f7106e05801485b8b15d879e0560dc7179c42b7107"
    sha256                               arm64_sonoma:  "1719419ea9d3214c33fed7f7106e05801485b8b15d879e0560dc7179c42b7107"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a1080046d9f26fedbea17ca3c5d357333fad8fe5b7872419738bd6378d1648d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72bc9a5ede34737e4264b65addfad62d17d0c10371f969c065a5df6e51050ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c13959d6443700a37138e44e214719c3893e9a427dada02aa5a876955dba88e4"
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