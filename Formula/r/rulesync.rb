class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-19.0.0.tgz"
  sha256 "e4051a646746c7aafe5f9f53aa6167ef4ef75a73954acf8f486efd4a4666d5ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78fdeabbb69abdbc6441294a8c7bb06b337f5719ebbd2460b9f880878c38a280"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78fdeabbb69abdbc6441294a8c7bb06b337f5719ebbd2460b9f880878c38a280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78fdeabbb69abdbc6441294a8c7bb06b337f5719ebbd2460b9f880878c38a280"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a2d29a587904cc868b697c49c3f7f622744b408930e4f36961c21995dc6ed3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2a2d29a587904cc868b697c49c3f7f622744b408930e4f36961c21995dc6ed3b"
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