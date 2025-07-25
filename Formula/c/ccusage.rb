class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.5.2.tgz"
  sha256 "7f89fd19aaeef74824235a8d3a72e5bd102a5e7fb40cbacf6dd759c1b68743e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a074b1c64c92bd6fa327caabb6547012ee10fa7076639b1f903bf2f95ebfc535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a074b1c64c92bd6fa327caabb6547012ee10fa7076639b1f903bf2f95ebfc535"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a074b1c64c92bd6fa327caabb6547012ee10fa7076639b1f903bf2f95ebfc535"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b271b36bbb809022c85e32641efd2aa766ce3b7a6bcc9d8d950e084e2d66959"
    sha256 cellar: :any_skip_relocation, ventura:       "3b271b36bbb809022c85e32641efd2aa766ce3b7a6bcc9d8d950e084e2d66959"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a074b1c64c92bd6fa327caabb6547012ee10fa7076639b1f903bf2f95ebfc535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a074b1c64c92bd6fa327caabb6547012ee10fa7076639b1f903bf2f95ebfc535"
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