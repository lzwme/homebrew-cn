class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.0.1.tgz"
  sha256 "fa45e6106c0eb2028b48b038c379908e013ceac1eb0479e9a5d8b4f73ed1230b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d71684409bd34d2201f3ad1ac604a147cb32aea91cc1d6ea83d763fba04bf120"
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