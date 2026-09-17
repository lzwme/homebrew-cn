class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.33.0.tgz"
  sha256 "923870d01d0ffafd8cec231c7ebcf0dabb4933958cae28870b84085c47253a7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08f5f1be6cd6d7c05206a451214f3944cfbded8b18add4b035c3c7d17acd60b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08f5f1be6cd6d7c05206a451214f3944cfbded8b18add4b035c3c7d17acd60b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08f5f1be6cd6d7c05206a451214f3944cfbded8b18add4b035c3c7d17acd60b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f5a3cd9431e76f5aaa6095e1b019fc448288205f3df5ae91b7a4abc1b684829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7f5a3cd9431e76f5aaa6095e1b019fc448288205f3df5ae91b7a4abc1b684829"
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