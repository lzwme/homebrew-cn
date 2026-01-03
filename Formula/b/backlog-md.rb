class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.28.1.tgz"
  sha256 "1861fdf394ea6a8e0e296d0f8e03c15757c3c8af0b407fb9b3900d2439042cdf"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4e4451a46953eb66fcbb548a0b8633b2c2b10b1e67f3f9ad3e49fc8aeb25485b"
    sha256                               arm64_sequoia: "4e4451a46953eb66fcbb548a0b8633b2c2b10b1e67f3f9ad3e49fc8aeb25485b"
    sha256                               arm64_sonoma:  "4e4451a46953eb66fcbb548a0b8633b2c2b10b1e67f3f9ad3e49fc8aeb25485b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4ba0fc7588048f93e2962da7b767a9a9bb0769372cc1c99cb99099e413dddfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e920c264fa099090dd86c6c7448307e1a18c5735f7d82e6712c041d7db2a1789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a42bd83d8f4950a218785d99a7503d7ca2b215538d9e5187ff83eb9010339473"
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