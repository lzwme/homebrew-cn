class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.26.0.tgz"
  sha256 "13a9b18b7b25c094fe20e2cc332172243afba24a9d5dc30a975c39f2d401bbf8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "76f9edf0ed7a9a1edc7730d87cf9d15bfc9ad503f6195a21c7609bf65dd7ac80"
    sha256                               arm64_sequoia: "76f9edf0ed7a9a1edc7730d87cf9d15bfc9ad503f6195a21c7609bf65dd7ac80"
    sha256                               arm64_sonoma:  "76f9edf0ed7a9a1edc7730d87cf9d15bfc9ad503f6195a21c7609bf65dd7ac80"
    sha256 cellar: :any_skip_relocation, sonoma:        "8906d71f66899507c6f0006754aa4ff25c83fa7e04f205f3a86db32a1055d102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "687055b1b075cdafb9c623a05332976ce1cac5975778342e352f1094e4d97470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b19aa9cc21f0f0eeb59ed5f18cb33e903b154bed32442627d28d415628f991f8"
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