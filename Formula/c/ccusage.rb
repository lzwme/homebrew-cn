class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.1.5.tgz"
  sha256 "acffb2b644cf0a034b83f9cca850060af72bfa6186e3ea50a56ff59d47f24449"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62f07a2a84ee78c191d144cdcda8abe2d35b4f30f99df996f6f6ef3d961c9c68"
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