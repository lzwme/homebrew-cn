class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.17.2.tgz"
  sha256 "57407e818497af8238b6bf687dff29817b533d38459cf6245975eb492be6d656"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "58c7b22c47a87162f9d2322dff6c22273343b9dd885cb93675b3d7a7a935b81c"
    sha256                               arm64_sequoia: "58c7b22c47a87162f9d2322dff6c22273343b9dd885cb93675b3d7a7a935b81c"
    sha256                               arm64_sonoma:  "58c7b22c47a87162f9d2322dff6c22273343b9dd885cb93675b3d7a7a935b81c"
    sha256 cellar: :any_skip_relocation, sonoma:        "835d1bc987310693405ee13fd80333ed7ffc0a744108e9648180057f4d6262d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e36e7090f83dd2c9e4e3cc15a840ab6e2b5010c0acd270096ec7b215779926a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "584bab5913ff493b29777e1b04e0e3e73245e608fc5676de8aa782a06c8b0627"
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