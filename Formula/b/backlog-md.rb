class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.12.0.tgz"
  sha256 "423bb93f9b1158b3fb7cc5c7f175dd2a231446c1bab6704e11d5ed2d3a04808c"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "ece7f9d4e8d2fd0f311a09c6dae1eac540fed9cbe900f239f920e427e6c1fd5c"
    sha256                               arm64_sonoma:  "ece7f9d4e8d2fd0f311a09c6dae1eac540fed9cbe900f239f920e427e6c1fd5c"
    sha256                               arm64_ventura: "ece7f9d4e8d2fd0f311a09c6dae1eac540fed9cbe900f239f920e427e6c1fd5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa0c5adb0e7188a5ca72f68e5e838b3c5475f948dd6367a898a51cbdc97a7d64"
    sha256 cellar: :any_skip_relocation, ventura:       "fa0c5adb0e7188a5ca72f68e5e838b3c5475f948dd6367a898a51cbdc97a7d64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "585da6453ef1f97de954607d72e5c8fbb2080d106dfc6f636a7ebd9d3c099a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0fc18b31c68f993d6ef5ed9afec88424d6bdae7c86bfaa5aab484413a3b7846"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end