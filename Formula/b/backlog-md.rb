class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.46.1.tgz"
  sha256 "149e0421fbd29bf5d35c5cc1d10640d57c7e8c5cca69172a4a47e46275321724"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "702e4ce57b308b81c31517d4aac19859bb0798db570ab26f01927a99b42fa716"
    sha256                               arm64_sequoia: "702e4ce57b308b81c31517d4aac19859bb0798db570ab26f01927a99b42fa716"
    sha256                               arm64_sonoma:  "702e4ce57b308b81c31517d4aac19859bb0798db570ab26f01927a99b42fa716"
    sha256 cellar: :any_skip_relocation, sonoma:        "956395203ea1b6293573a42239a3c54b7f2c6055fba09130f7d4e7ec9e24b4ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71972ba53d36071532565adf877bb332ae110fcb3b820ad986f428f9ba930e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa4867570c95e446ce570d533a890c41cc860d2eac5d1df544a25b85829317d3"
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