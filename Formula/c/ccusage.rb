class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.5.1.tgz"
  sha256 "7451955f6a76871fecc1bb0e144554e0d61165f2c4a3925e372a87192b86a8e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a5c98687bb444201f7c64f207ed87f0cbd6f7a29f413334cc861fd2dee8e503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a5c98687bb444201f7c64f207ed87f0cbd6f7a29f413334cc861fd2dee8e503"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a5c98687bb444201f7c64f207ed87f0cbd6f7a29f413334cc861fd2dee8e503"
    sha256 cellar: :any_skip_relocation, sonoma:        "9269173915a17a527050db05c7e25914adefbcddaadc42658327cd286a556bf4"
    sha256 cellar: :any_skip_relocation, ventura:       "9269173915a17a527050db05c7e25914adefbcddaadc42658327cd286a556bf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a5c98687bb444201f7c64f207ed87f0cbd6f7a29f413334cc861fd2dee8e503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5c98687bb444201f7c64f207ed87f0cbd6f7a29f413334cc861fd2dee8e503"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output(bin/"ccusage 2>&1", 1)
  end
end