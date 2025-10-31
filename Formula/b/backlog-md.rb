class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.18.5.tgz"
  sha256 "8f4eb6ab6b0ff0a676f5b98916b425bae34bd13c48ff0e63e0b4153cfd5487a5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "01ed6020336546f5684eedd0622ba034682c8023ff16c7a9b01bb552fdb1179a"
    sha256                               arm64_sequoia: "01ed6020336546f5684eedd0622ba034682c8023ff16c7a9b01bb552fdb1179a"
    sha256                               arm64_sonoma:  "01ed6020336546f5684eedd0622ba034682c8023ff16c7a9b01bb552fdb1179a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdbee76594f3dbc39dc2a7e5829a520408a82cfb87ab7bdc54287b4a47784a81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7577e6185dfda6f905faba4962d785063795910be25f322b3c503023e4d5aa3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be563c3a21f048edef5b515ff1717ab85bf6050e1407001ce590bbf44a7080a8"
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