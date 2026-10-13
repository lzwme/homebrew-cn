class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-32.0.0.tgz"
  sha256 "f08fbddbe7b91e1193ff92cf28e6072e794bda841e9e11ebef3d9fee56df503a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0aae2a0f6d5b07513ec9777781a193a1cd749df255281d821c02470509027200"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be03efd55be240a7a21d1f71003e70e3e9cc2eb0ce53f7b8836bfaaf7b987d56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be03efd55be240a7a21d1f71003e70e3e9cc2eb0ce53f7b8836bfaaf7b987d56"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0d8bbabffca3b6c48e229040e4a5d1a83a49f0723f45dbb74f7d17b843d5ff15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0d8bbabffca3b6c48e229040e4a5d1a83a49f0723f45dbb74f7d17b843d5ff15"
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