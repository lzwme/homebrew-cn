class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-24.0.0.tgz"
  sha256 "4b379114fb406ba0e344705cc73405101b3dc6126ed13bb98310d07c24a3b9ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0d557867ca1eebf958cc64fa37f6d56cb221bc46761e1dd0644c5ed2306b15d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0d557867ca1eebf958cc64fa37f6d56cb221bc46761e1dd0644c5ed2306b15d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0d557867ca1eebf958cc64fa37f6d56cb221bc46761e1dd0644c5ed2306b15d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "79d27c36af5c375d542f355c15cf2c7d997b8a0b41a02ce19b39b3786fbf8ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "79d27c36af5c375d542f355c15cf2c7d997b8a0b41a02ce19b39b3786fbf8ace"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end