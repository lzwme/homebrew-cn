class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.2.0.tgz"
  sha256 "29928e5aa8a017f4ac5823467ef496235756398960228c0b11b676b2408df00c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df42090b406f1a08659aefbafbec58489a82f43778ab15c1d5760d4907fc2da9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df42090b406f1a08659aefbafbec58489a82f43778ab15c1d5760d4907fc2da9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df42090b406f1a08659aefbafbec58489a82f43778ab15c1d5760d4907fc2da9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "654035eac1e84296cf4c3be4e19c34afd51bcd5bf24b1bcdc658eb040feab10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "654035eac1e84296cf4c3be4e19c34afd51bcd5bf24b1bcdc658eb040feab10b"
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