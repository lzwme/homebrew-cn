class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.17.0.tgz"
  sha256 "d2ceafa33c271ff9fa19307e94b745b09381682055aeb5a9edc764c6c0a0c577"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9623411529fafe564163a1c27a073159cb032d453b00f7d6aee926df420c4330"
    sha256                               arm64_sequoia: "9623411529fafe564163a1c27a073159cb032d453b00f7d6aee926df420c4330"
    sha256                               arm64_sonoma:  "9623411529fafe564163a1c27a073159cb032d453b00f7d6aee926df420c4330"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc710bd0ff9de87c001f516e0caac4ba9e00129d3c36ea8d5fd87956c76df7b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6811c94a28bebafd1fa91b9741dfb6a408b9fc73410c19e5bacaa9aa9672aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4839fb8f98265cad838508d78353165d8eb4721165fc25f92d460a1b393ea1aa"
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