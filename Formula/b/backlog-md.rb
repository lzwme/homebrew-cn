class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.49.3.tgz"
  sha256 "7f11e8e61372814aeef14c1be175fb8b97fa830d1bc429092caf9a70fd2464c6"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "43e66564e835ad2207d5ca90ce465582830a0dc400723682db417c011286c271"
    sha256                               arm64_sequoia: "43e66564e835ad2207d5ca90ce465582830a0dc400723682db417c011286c271"
    sha256                               arm64_sonoma:  "43e66564e835ad2207d5ca90ce465582830a0dc400723682db417c011286c271"
    sha256 cellar: :any_skip_relocation, sonoma:        "04400aceddea32e65532eaa87307fe5ac0e54b74d12350fb33d1fc634dc556b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe33862d894d152ebc889799180d226aa2423cdc4d4d81fff168b35a020f0875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab1e6bdcd5c0948680bfec9aedd0ae492a36addc202738a8375693d4bd3f90f"
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