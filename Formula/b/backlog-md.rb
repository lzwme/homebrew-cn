class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.15.2.tgz"
  sha256 "6efd6eb4954ba10bfa9b8ae0d2549e35d594960f1c20ff342373045c3af9d1c0"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fb29e8d9fc0a0a8af677f2a20a6231789bdf26f8e70fef3b81cc4ac7bd0fd825"
    sha256                               arm64_sequoia: "fb29e8d9fc0a0a8af677f2a20a6231789bdf26f8e70fef3b81cc4ac7bd0fd825"
    sha256                               arm64_sonoma:  "fb29e8d9fc0a0a8af677f2a20a6231789bdf26f8e70fef3b81cc4ac7bd0fd825"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebbc8a300e42de3b70733bb1ed8819adaf292925f1e17eb87a3e11f87ac1043a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c2d1cbffd25ed54815da3c42a75c62be09e14cbe9ff7600bfae33d669da3522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e74a76a7b022c4d5b3f43923303b12f2e59b8b8749db5da8ade38c4a068bf3ca"
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