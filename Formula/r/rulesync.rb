class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.27.0.tgz"
  sha256 "02515eb11f4f6680019b22bf43ff27361fc56c621e5b8e48c6ee0ac3d4c4e4f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df90696206e0c80111ab119ad6be550799b4d2e890d13d274f5fa472913662a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df90696206e0c80111ab119ad6be550799b4d2e890d13d274f5fa472913662a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df90696206e0c80111ab119ad6be550799b4d2e890d13d274f5fa472913662a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4e49e6f03ae447a2447dca4595b2b3496ac2580c882b837c2bbd0fd4f3c7c85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4e49e6f03ae447a2447dca4595b2b3496ac2580c882b837c2bbd0fd4f3c7c85a"
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