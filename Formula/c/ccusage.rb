class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.9.1.tgz"
  sha256 "5b59e53097d4d0c94c4694791077583860ca93211bb11ffb6c0d7703d8661950"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "133b31768a3adebe89454976f29b512bbe9ff669356f064f3a7a7bc0b3e63141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "133b31768a3adebe89454976f29b512bbe9ff669356f064f3a7a7bc0b3e63141"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "133b31768a3adebe89454976f29b512bbe9ff669356f064f3a7a7bc0b3e63141"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b6c8e1475b449f4d64314a03873521b21ec550cc258fa996f5674c6976fbd07"
    sha256 cellar: :any_skip_relocation, ventura:       "6b6c8e1475b449f4d64314a03873521b21ec550cc258fa996f5674c6976fbd07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "133b31768a3adebe89454976f29b512bbe9ff669356f064f3a7a7bc0b3e63141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133b31768a3adebe89454976f29b512bbe9ff669356f064f3a7a7bc0b3e63141"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end