class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.0.3.tgz"
  sha256 "b5f213e38818b74413d5c0bf5ba7d89dd952603d115a14ca469f78424c048bfd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c407827a2187467d3fa66655534f896803ac3b58aea2b203fc97210b39dff872"
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