class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-33.0.0.tgz"
  sha256 "c22771a52938e0354d36d0586f98571d58aabdd9f5800476a2ce0cb6ca07b91f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db12d4f96d57a97e25e8aaac62dcdd94b3de73d9a1f7a5de2b5c73e687d01930"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db12d4f96d57a97e25e8aaac62dcdd94b3de73d9a1f7a5de2b5c73e687d01930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db12d4f96d57a97e25e8aaac62dcdd94b3de73d9a1f7a5de2b5c73e687d01930"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c4024334b5f617da9daa8e5aaf70bb1e2502de7d7ea2bbc037444771d4d4c066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c4024334b5f617da9daa8e5aaf70bb1e2502de7d7ea2bbc037444771d4d4c066"
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