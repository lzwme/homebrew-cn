class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.0.0.tgz"
  sha256 "edd3a754771c724cceb6ab0f0a505e449614bd393aefd5d4f6b88d0682b26fd4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ff2842dfbc41b0be65c40f34dd0f7cd3dd1034172c4fa171b2f43921e41654b"
    sha256 cellar: :any,                 arm64_sonoma:  "5ff2842dfbc41b0be65c40f34dd0f7cd3dd1034172c4fa171b2f43921e41654b"
    sha256 cellar: :any,                 arm64_ventura: "5ff2842dfbc41b0be65c40f34dd0f7cd3dd1034172c4fa171b2f43921e41654b"
    sha256 cellar: :any,                 sonoma:        "4ff0c88dff92e1579767fd401da4b3e21edc9c35b8117c9e8fb71f3a7d1366c4"
    sha256 cellar: :any,                 ventura:       "4ff0c88dff92e1579767fd401da4b3e21edc9c35b8117c9e8fb71f3a7d1366c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8124f22e16339cc5b66f4dc2b5e54757472f0e06aee3be34e55c64c70e7164f2"
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