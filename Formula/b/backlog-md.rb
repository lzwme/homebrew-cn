class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.17.3.tgz"
  sha256 "0f17ee7774cdfeca864791c1b96c80c825a5b1730c273cd7ca30d794e8fac663"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "09678c472bb6f5ac07b10d81677763975d4fd12704580b452102d353fc66729d"
    sha256                               arm64_sequoia: "09678c472bb6f5ac07b10d81677763975d4fd12704580b452102d353fc66729d"
    sha256                               arm64_sonoma:  "09678c472bb6f5ac07b10d81677763975d4fd12704580b452102d353fc66729d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff64c5c8fc1ff19673e47d0dfc15f9000240d89554f7d322308834993ff648a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "484d1b70cc000d37015afd332d4490e9a7e70d8239e5d850e8d0a9bccecea7cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f053eeef5f446bc96252446db43a82b126fd975dd6a2f125962a4d143c38dfca"
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