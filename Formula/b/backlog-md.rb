class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.50.0.tgz"
  sha256 "ba9a2a836ee58ff8b04ba519e99f725ef87bf8f386a0ddaa0225244763fdeb05"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9eb6870790d81cf3049e5539cef8be2b1413a1437c76e043525c0cde982605e3"
    sha256                               arm64_sequoia: "9eb6870790d81cf3049e5539cef8be2b1413a1437c76e043525c0cde982605e3"
    sha256                               arm64_sonoma:  "9eb6870790d81cf3049e5539cef8be2b1413a1437c76e043525c0cde982605e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "61dbadc7002f91044124505e2ef371234865df0e709988789d2c38af5b900472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "015f4c5727d5b0261d45cd6b27c40ed1ce63beb2123df7c9e5b66e542844c620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e456c4882f8733e191cd78f4cc4cfb8b370968b03152e6cb15adf4ae4c542c0"
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