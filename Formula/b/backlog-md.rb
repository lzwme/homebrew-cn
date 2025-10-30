class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.18.3.tgz"
  sha256 "0b5178873f823ae8300fb495e5a82f62da0b58dc841aa3fe61f4980a0656c61a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9505668231a89c22b1d967088995ebac6191237df95e9a99481c00216a87a94d"
    sha256                               arm64_sequoia: "9505668231a89c22b1d967088995ebac6191237df95e9a99481c00216a87a94d"
    sha256                               arm64_sonoma:  "9505668231a89c22b1d967088995ebac6191237df95e9a99481c00216a87a94d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8a4a7e031b8a60a8080f6d70754485a36b90293ef32b7cc1ee13f718ea2f269"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7ea6014b3417f7b963db59f6de4f5f9f4d89c29025a534723d319e61733dbd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65e76006790a03a28afc4f1a3cc34c01d54b776628589b72a437d27a9bf6f510"
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