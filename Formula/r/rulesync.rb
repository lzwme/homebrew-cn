class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.0.0.tgz"
  sha256 "3c55d0e08436571801b0bf9a5fa68afa6755487c17ecff8e3743814f8c9c679b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31851f42a9851d6dd151f1bc67c2a622b3bb2de2d420a24d1b2a44de0427b41d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31851f42a9851d6dd151f1bc67c2a622b3bb2de2d420a24d1b2a44de0427b41d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31851f42a9851d6dd151f1bc67c2a622b3bb2de2d420a24d1b2a44de0427b41d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8288d48d38e9be02f5f2f30e2414076754ec5bb7fed0b8c88379abc496f24e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8288d48d38e9be02f5f2f30e2414076754ec5bb7fed0b8c88379abc496f24e4c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end