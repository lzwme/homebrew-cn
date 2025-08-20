class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.10.0.tgz"
  sha256 "d35806699298a2baa329a550f35c2eb207dc0573933be4c67df32ba7646a8440"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb1ddef637c9b107e99fd67cd99027f123a84774c452a3000c6c749b4f76ede9"
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