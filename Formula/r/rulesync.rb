class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-29.0.0.tgz"
  sha256 "682e2831e1c3703cdfab321c01ff1f5c6c92b7d5246be271c545fd1d917f2fb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cbe4c1bca1a78659fe1e154b05641270f9dc668edb899ff36c4079252fa9013"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cbe4c1bca1a78659fe1e154b05641270f9dc668edb899ff36c4079252fa9013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4cbe4c1bca1a78659fe1e154b05641270f9dc668edb899ff36c4079252fa9013"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86440f2f144bd1032e9db983a6cd485bbfbdc004fc6ebf3851efae1818ef81ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "86440f2f144bd1032e9db983a6cd485bbfbdc004fc6ebf3851efae1818ef81ea"
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