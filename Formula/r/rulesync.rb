class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-12.0.0.tgz"
  sha256 "9188ce1d1dae00adc2683004188277b36728f6be71a393337982441d476818c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "344f8e00035df761b2747130979a7c7f3e3bde01841f26646a7f46c3f3dbc871"
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