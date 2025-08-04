class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.6.0.tgz"
  sha256 "6da64a73e92057efd4c623446bb04e5420f98d220a1693f64111dd27871438c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7d73ac9dfef6679a13e9f6ba936f7820717a0798aceaa25a06dbdd73cbe05c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7d73ac9dfef6679a13e9f6ba936f7820717a0798aceaa25a06dbdd73cbe05c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7d73ac9dfef6679a13e9f6ba936f7820717a0798aceaa25a06dbdd73cbe05c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa51770e22513525e2d93f3af80bc41af0d3ec85c6d030f7bacceaffaece027"
    sha256 cellar: :any_skip_relocation, ventura:       "2fa51770e22513525e2d93f3af80bc41af0d3ec85c6d030f7bacceaffaece027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7d73ac9dfef6679a13e9f6ba936f7820717a0798aceaa25a06dbdd73cbe05c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7d73ac9dfef6679a13e9f6ba936f7820717a0798aceaa25a06dbdd73cbe05c6"
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