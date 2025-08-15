class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.62.0.tgz"
  sha256 "9c679a830ff2310bbff713ac56d52f70ed5697c5d2a712881b26a9037194a7fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a194f6dc88c7e00e7ea011320397807dfcb28c3e1e75508e1eb379873674854"
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

    output = shell_output("#{bin}/rulesync status")
    assert_match ".rulesync directory: ✅ Found", output
  end
end