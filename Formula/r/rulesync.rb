class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.39.0.tgz"
  sha256 "b3ee26e3450dd356eff7c507ca110ccbf4267ad812c1bedb0ae8523c83f3699d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3d547a9c46c4f061b45301d82f609b93081ef9a4c71c14e3ffb7ac426952cb0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3d547a9c46c4f061b45301d82f609b93081ef9a4c71c14e3ffb7ac426952cb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3d547a9c46c4f061b45301d82f609b93081ef9a4c71c14e3ffb7ac426952cb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd2c4966cbc38b001b71ce44ebe3a91f9d05df56e6bc2eb97333ef1b18807f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dd2c4966cbc38b001b71ce44ebe3a91f9d05df56e6bc2eb97333ef1b18807f26"
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