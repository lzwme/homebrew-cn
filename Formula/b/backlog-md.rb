class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.35.7.tgz"
  sha256 "844292bbee364a7c4e973ed409271f51aeabe01597314f008570c12c206da8aa"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "688bfa356800fc4a0ee7ee36437e411da4c52d5328fb5ccfab2311f8ea8d3732"
    sha256                               arm64_sequoia: "688bfa356800fc4a0ee7ee36437e411da4c52d5328fb5ccfab2311f8ea8d3732"
    sha256                               arm64_sonoma:  "688bfa356800fc4a0ee7ee36437e411da4c52d5328fb5ccfab2311f8ea8d3732"
    sha256 cellar: :any_skip_relocation, sonoma:        "410bab90b24ca117d07fa6a06fc54a9f3bb41c7b60fc660cbf5bf7cd0540a5e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "235daa783f90899464e1d2251b7398dda0e10b2dd01fa0dc0049fb686331e9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30467c0159c00118a10262ae414d4926de7e76329d05bb7e9bfec32434c8fe75"
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