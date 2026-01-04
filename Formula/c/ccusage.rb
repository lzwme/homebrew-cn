class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.2.1.tgz"
  sha256 "4dccdc122e1a8a80fc3986dd420576598534f843f2480451793ccbcca20311e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1f826b56ba02505be5d6c47d91940ccbaef8bcbbb568453f709e8d7573d0cae"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end