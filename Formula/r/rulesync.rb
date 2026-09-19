class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.38.0.tgz"
  sha256 "c0da58662a453122bf78a6ce9f4bbf2729fbeadbf7701b5418fc8f5e300d9bf0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd80a7c7f7fb445d7df8fa6846b40e42ffc3eb46eeac6583ba918b14d0470f35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd80a7c7f7fb445d7df8fa6846b40e42ffc3eb46eeac6583ba918b14d0470f35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd80a7c7f7fb445d7df8fa6846b40e42ffc3eb46eeac6583ba918b14d0470f35"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e4fc7c220e607b9355dc9d3c1df47c9cbf60ce06907ee3113b42453b9ae11d19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e4fc7c220e607b9355dc9d3c1df47c9cbf60ce06907ee3113b42453b9ae11d19"
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