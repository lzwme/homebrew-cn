class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.0.15.tgz"
  sha256 "137e30304177cb3a8e2bc64f79a0af83e951107b25c66b151aa0e5d0c26b3e94"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "78d956d1eee116f04f2cd1188fa6efa74a43017009428e935976d7d9a67ef90a"
    sha256 cellar: :any, arm64_tahoe:       "555fe8512ef1fc67e34ef224ab4e30c1f1ab0318e9d02bef1c0da2d66f5a7e6d"
    sha256 cellar: :any, arm64_sequoia:     "c4f3e98643fd8d27171203c1c03534ec840d22d19a63d4da2e6f79b0d4a9d8fc"
    sha256 cellar: :any, arm64_linux:       "95808e04fff67035eaaa13382cc902e26f411da9d8c861380ec29cdc67541652"
    sha256 cellar: :any, x86_64_linux:      "5bcd45a5581f191b6e6eda39a0fadcb6b2efd9fc92d4a517d0daf0650711e5bd"
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