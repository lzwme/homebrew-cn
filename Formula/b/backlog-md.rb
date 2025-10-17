class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.16.5.tgz"
  sha256 "8a8631e44db3277259a3a6bfb939574e63d388c820220dfe4969eb2b0ed48fc9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ab3327d5cdb15d854d0a9fb6837deec0e56246d15b36436ae4ac0f26f4c45e5d"
    sha256                               arm64_sequoia: "ab3327d5cdb15d854d0a9fb6837deec0e56246d15b36436ae4ac0f26f4c45e5d"
    sha256                               arm64_sonoma:  "ab3327d5cdb15d854d0a9fb6837deec0e56246d15b36436ae4ac0f26f4c45e5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "32ce7cf0215fd98b3251273b59c7022cf0e932774b28ae764f970dbff742c042"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "177e868c18acba6095bbc9fd588645fe0ab1f07b829e576cc3e4d5eab45cc642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36368046acd0afff5fee36a9bd6b03f1fc6e58a958908a8c56ad7b5ba8626325"
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