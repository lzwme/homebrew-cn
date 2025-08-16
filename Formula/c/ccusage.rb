class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.9.7.tgz"
  sha256 "4dfc4b0a3e54c8744d76ac4e106d9de8c0e4b80fd12a7486c1ff4cee172f62f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3541a684b0823b7639b7c789302f376cb9e147c6f84ecafe057c0a7cfd4887c0"
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