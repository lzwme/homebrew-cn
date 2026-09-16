class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.32.1.tgz"
  sha256 "f7f7bb17308b64ae14580f36102846ff3ebef38b221c72461e1d4a528b3f1687"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ce2a100ef1f5eab45e9bc44af106c334baa3a4b2f3a778a68affb91c9cca5cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ce2a100ef1f5eab45e9bc44af106c334baa3a4b2f3a778a68affb91c9cca5cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ce2a100ef1f5eab45e9bc44af106c334baa3a4b2f3a778a68affb91c9cca5cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e288af49cb281b6bb0c422110620c96c21ae8d38b15189ce521695c8f9c20aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e288af49cb281b6bb0c422110620c96c21ae8d38b15189ce521695c8f9c20aa9"
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