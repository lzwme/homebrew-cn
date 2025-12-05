class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.26.2.tgz"
  sha256 "ed9ac3b252dbcfb7d90eaa454f4f68273fde8f8d772a3eb48a1d63f4b3b8cce8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2c0486d427e95b4ced7a4e9c9678540f3716170686f4b3b2f916964260c948e8"
    sha256                               arm64_sequoia: "2c0486d427e95b4ced7a4e9c9678540f3716170686f4b3b2f916964260c948e8"
    sha256                               arm64_sonoma:  "2c0486d427e95b4ced7a4e9c9678540f3716170686f4b3b2f916964260c948e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4650b969c8a3e8e93fdb3159c98652b4364d8b29429dd152f7a53c7800fddefa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d2734187f3480bf0c155a976f81c6f2b99c49557a9723706309b3f08f0f3359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6c6cfaa797c7503d193dcd4442dae5a0cef07f3466626651ff0f1f5f71bcbf"
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