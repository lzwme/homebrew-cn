class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.23.2.tgz"
  sha256 "d2e9ad8b914f2f4d5a504f5e6f658ba2511190dbc944ce36abf04fc1c76c0783"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ccdd95c632d52bcbc417b201d1f9655acf2d6d5b8b117dd2469ad7455c34c0eb"
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