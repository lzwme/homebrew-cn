class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.35.2.tgz"
  sha256 "11a5ce564ba9888ab4b50563cf818c9f1747df651e936e9d2ed8c2f64eb0beeb"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "64c62a2f632c267601bd0370b86a1966122f72eff6df132a85ef5ce2e7a26d6e"
    sha256                               arm64_sequoia: "64c62a2f632c267601bd0370b86a1966122f72eff6df132a85ef5ce2e7a26d6e"
    sha256                               arm64_sonoma:  "64c62a2f632c267601bd0370b86a1966122f72eff6df132a85ef5ce2e7a26d6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "82436a48e778849ad7dd4cb77fcac639850112258288f2bb5535fb73ca2579e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c75eb9152722d7ef0562609abedb76a7fdf25990320d44b04ada55dd372b491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4b753667d14ebe4bd0ce131ea307c94edfa1ccb899c551bf40c72119b43ac5e"
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