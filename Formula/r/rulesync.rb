class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-18.0.0.tgz"
  sha256 "af13516aa18aa63191ef9b9ad40bc1a8a7afdf36a1e75d5e0d1e1523076b20f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "def50ae294a5d8df3c4cc35c8cb6c13a97137a36766053d414a5a6be687878b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "def50ae294a5d8df3c4cc35c8cb6c13a97137a36766053d414a5a6be687878b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "def50ae294a5d8df3c4cc35c8cb6c13a97137a36766053d414a5a6be687878b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "938f31dc999d28ae00d4c9f56cf759ccc7f8fb31e4cb3a5ce0d545b1354e2506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "938f31dc999d28ae00d4c9f56cf759ccc7f8fb31e4cb3a5ce0d545b1354e2506"
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