class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.29.0.tgz"
  sha256 "b5aaadba3c2196974d9c423f3e0b605d3c7b0d71570eba86da5135ba394b20e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f37a59eae94fcb195c300de76f04a363c39421b2079e59265a97ca768377d3fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f37a59eae94fcb195c300de76f04a363c39421b2079e59265a97ca768377d3fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f37a59eae94fcb195c300de76f04a363c39421b2079e59265a97ca768377d3fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd78f693b16f534c1c96f0c04e61d9e1f8d43f5c3e7206e6e3d3f69ab3f00c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fd78f693b16f534c1c96f0c04e61d9e1f8d43f5c3e7206e6e3d3f69ab3f00c5f"
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