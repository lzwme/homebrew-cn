class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.0.1.tgz"
  sha256 "863ccfbf7f57ae04936afdc4250e5574d0f7fb2e2e6eb7fc3ac27333a2610ca3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6dc9b226900eb257332cea9f378700ecb5e4d2cfff11c12c91e921be6482b617"
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