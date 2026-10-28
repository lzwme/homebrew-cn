class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.15.0.tgz"
  sha256 "bed7b6ae754c9b11b2f64e823671428015ed90ea37492ff7bc5f883da5bd3dc6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "516d760f11239ae97fbca7d72501d1a10a8c3f8d777546ba0dba90580952ed92"
    sha256 cellar: :any, arm64_tahoe:       "c0cf4b302514c6710c5f9480a03419b8f632bc0ebf3b19efccdc0a34775aef37"
    sha256 cellar: :any, arm64_sequoia:     "68aeca7755ff72c54ba2842b2ad27e48ec0aa0e5faace9888a750cc48bd4ed12"
    sha256 cellar: :any, arm64_linux:       "966769a2166286ebe539d475e298db710f54f8e2b9d14d30374e0eba2d0d4d40"
    sha256 cellar: :any, x86_64_linux:      "b31b809e216f59c6bde339a72149b67e62ee1a50a9d9586d4be00bc387001c67"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end