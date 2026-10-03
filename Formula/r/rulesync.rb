class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-25.0.0.tgz"
  sha256 "9837e687c34fe813e1a1feec54dd34929cb9b88226321bb738540757e95a4854"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3b644539c0df0db1ab7f928d1e081f50c38e7310e418120df7f4fed58d620c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3b644539c0df0db1ab7f928d1e081f50c38e7310e418120df7f4fed58d620c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3b644539c0df0db1ab7f928d1e081f50c38e7310e418120df7f4fed58d620c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2c44c6e5862d3965fb9c051fe9cd13d73d6f3f40a0a0cb66ab1ebf97c78fa5a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2c44c6e5862d3965fb9c051fe9cd13d73d6f3f40a0a0cb66ab1ebf97c78fa5a1"
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