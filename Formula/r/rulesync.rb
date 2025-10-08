class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.3.0.tgz"
  sha256 "3f131ba749fc1f2459cb11a9054831bcc97d0ac86e1c05d1207630f485d9e422"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3340cf871497207485a2f09cfacf23a204134bc9c7eb1bd17603082a1123a6c4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end