class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.17.4.tgz"
  sha256 "31dec50c2e39073283e34bcc49e7ec209383e277df2094fc2e5e40ba96402a18"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "10a090d7a19c3db2e3017ba88d37729ce7215b5a76179b1c32dcc36b2eaabbe4"
    sha256                               arm64_sequoia: "10a090d7a19c3db2e3017ba88d37729ce7215b5a76179b1c32dcc36b2eaabbe4"
    sha256                               arm64_sonoma:  "10a090d7a19c3db2e3017ba88d37729ce7215b5a76179b1c32dcc36b2eaabbe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c33028d8b649e168abc543f24390ad8dbd0f0641957f13d461b3188bca1c71f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d04df2e8557dae4a00259e30b6259c8db1fcd0b2fa31ca38e2b3c33bfb9d23e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1aace2f3862268ab7428221feb8308d8b2288573bb20f20edf89e019fbbf658"
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