class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.0.1.tgz"
  sha256 "78904f63711ed5d2a654258e3e5f30124773d81746ad7fd31dd255f49fe12db5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d88a3b0988f2116ca5beb77357df73e8bb6da8fd854cbb2b7c74c25e86004be"
    sha256 cellar: :any,                 arm64_sequoia: "5e21739c97c607ae32e3d59176456392466607369e191cea965df9ad546e74a4"
    sha256 cellar: :any,                 arm64_sonoma:  "5e21739c97c607ae32e3d59176456392466607369e191cea965df9ad546e74a4"
    sha256 cellar: :any,                 sonoma:        "07a558015fc8f7c65e3c9977cbcadf240032ed0172f41d9d92a16b71edc7b51b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50fac48b275807586a3ad1fa75d8a0804536840ac4da8ea6a0aec5d8fa00483"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/tdd-guard/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-code/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
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