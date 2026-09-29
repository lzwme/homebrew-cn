class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-22.0.0.tgz"
  sha256 "a0eb425b9d2fd48df93c91da4cd575c19ba71eeb3c93cb28b8aaae2763280bc8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e8e0045684a223fa73bd19e849be508571fe925a121abe77a0047d74300301d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8e0045684a223fa73bd19e849be508571fe925a121abe77a0047d74300301d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e8e0045684a223fa73bd19e849be508571fe925a121abe77a0047d74300301d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69ccaa0776d39123e6f8246e2d347af0404ec7a853dc9b80969e37c063ea047e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "69ccaa0776d39123e6f8246e2d347af0404ec7a853dc9b80969e37c063ea047e"
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