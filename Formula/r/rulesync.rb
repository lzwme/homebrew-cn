class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-27.0.0.tgz"
  sha256 "7760e08f39110bb9d8d43b99f1f73e31819cfa4ba9536512d992b807d91f832d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5c6c791cc5dcc02636e93dd5db0985266351709a6ebbf8b2944855380cd584be"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c6c791cc5dcc02636e93dd5db0985266351709a6ebbf8b2944855380cd584be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c6c791cc5dcc02636e93dd5db0985266351709a6ebbf8b2944855380cd584be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e450a05063ad0b97cf9820250207462a5e40d37fa8e579d43eaebf6862352a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5e450a05063ad0b97cf9820250207462a5e40d37fa8e579d43eaebf6862352a1"
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