class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.34.0.tgz"
  sha256 "6fab15316f96e09e341fd40446d4000f927c4f36dbb53c1d07d849f9fa816bc4"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "300c814af72e94ea888d4c4709b68bd9d31a0cba8f25dbab67dfa11e34fd095c"
    sha256                               arm64_sequoia: "300c814af72e94ea888d4c4709b68bd9d31a0cba8f25dbab67dfa11e34fd095c"
    sha256                               arm64_sonoma:  "300c814af72e94ea888d4c4709b68bd9d31a0cba8f25dbab67dfa11e34fd095c"
    sha256 cellar: :any_skip_relocation, sonoma:        "94833489dcd33de6e08f986f13131832f8f0f6e59bfa6dc5431d83a0ecfde7b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a9eac432c223ead41f038c35a35f960e83f0966fd8d8b4a63a8076d49fa4c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db0e3d07b7a1505c0d8f8610c39587dedc9a609271c69aa4c24a149d76e89b14"
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