class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.17.0.tgz"
  sha256 "1fecbe98c922b47aafe506dd972a28c22d7524ea8befce8fa0c615c486632d7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0278164a5740d704ffa7954043e9f78e999056472aef306be55ef53da88d0a7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0278164a5740d704ffa7954043e9f78e999056472aef306be55ef53da88d0a7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0278164a5740d704ffa7954043e9f78e999056472aef306be55ef53da88d0a7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b41447934938ca498f9725b7227f7519c541a351781a1da8a56c2506ce46142d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b41447934938ca498f9725b7227f7519c541a351781a1da8a56c2506ce46142d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b41447934938ca498f9725b7227f7519c541a351781a1da8a56c2506ce46142d"
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