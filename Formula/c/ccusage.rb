class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.8.0.tgz"
  sha256 "c02904fedd3a769c3bdf6a19275345eaed40b33d8871676caa2020af5d44211e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd7d9f17d684cc0b65aa496e49c87db1b453773cc04b65dcaeca6d3da7030119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd7d9f17d684cc0b65aa496e49c87db1b453773cc04b65dcaeca6d3da7030119"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd7d9f17d684cc0b65aa496e49c87db1b453773cc04b65dcaeca6d3da7030119"
    sha256 cellar: :any_skip_relocation, sonoma:        "9066ec3c6640eeb945b2ba59dd4911414b5b7c6df8d5dd630821e33e6e471d71"
    sha256 cellar: :any_skip_relocation, ventura:       "9066ec3c6640eeb945b2ba59dd4911414b5b7c6df8d5dd630821e33e6e471d71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd7d9f17d684cc0b65aa496e49c87db1b453773cc04b65dcaeca6d3da7030119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd7d9f17d684cc0b65aa496e49c87db1b453773cc04b65dcaeca6d3da7030119"
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