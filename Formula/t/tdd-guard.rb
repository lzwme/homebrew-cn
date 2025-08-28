class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-0.9.3.tgz"
  sha256 "92f4c8d3b91b21cbb2115219b2eb9d7e0f64c9277b0fa880bb898b33cdcea86f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71b36234c63db6cf404348012770eb91d7261cf3bba0a922a480b98c885f7768"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".env").write <<~EOS
      MODEL_TYPE=claude_cli
      USE_SYSTEM_CLAUDE=true
      LINTER_TYPE=eslint
    EOS

    input = <<~JSON
      {
        "event": "PreToolUse",
        "tool_use": {
          "name": "Write",
          "input": {
            "path": "example.py",
            "contents": "print('hello')"
          }
        }
      }
    JSON

    assert_match "reason", pipe_output(bin/"tdd-guard", input, 0)
  end
end