class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.9.4.tgz"
  sha256 "3683f585ad26747a204c137b69761e2037a7a9df4fc80100ca3778d36d22fedb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e857dd287ef706bef881d9b5cde8b6262d7fdcd0e0d63c6c22be40c78d7e995"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e857dd287ef706bef881d9b5cde8b6262d7fdcd0e0d63c6c22be40c78d7e995"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e857dd287ef706bef881d9b5cde8b6262d7fdcd0e0d63c6c22be40c78d7e995"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5a352f8cf8bb5c2808f9384e15ef5aa4f43fc182ec6ca13fb5d797af8ee7b49"
    sha256 cellar: :any_skip_relocation, ventura:       "e5a352f8cf8bb5c2808f9384e15ef5aa4f43fc182ec6ca13fb5d797af8ee7b49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e857dd287ef706bef881d9b5cde8b6262d7fdcd0e0d63c6c22be40c78d7e995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e857dd287ef706bef881d9b5cde8b6262d7fdcd0e0d63c6c22be40c78d7e995"
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