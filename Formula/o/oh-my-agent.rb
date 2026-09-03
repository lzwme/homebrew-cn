class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-13.1.1.tgz"
  sha256 "89098a181f9720ab8100a5fa86249287d9d25c63919b006de73f71d62fd5e5a7"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "37139dede3e8e9db2fdc51c7fcdd012bc082b9daf03b880da6cdb0eb0bb3d21e"
    sha256 cellar: :any, arm64_sequoia: "d05647844eb8ea542b36570577745d5ec9dee2f1cbbd77428a0235a249e8942f"
    sha256 cellar: :any, arm64_sonoma:  "07174d393b7d827851fce2088712bde51aaa964fc2847ffa384dbd16de1a1b7a"
    sha256 cellar: :any, arm64_linux:   "a536da3423164b39bcb08d052d97024cb9ccf5310012a729e9494e4536a370b0"
    sha256 cellar: :any, x86_64_linux:  "63dcfdf1ea868751ff684a2024683d04be6f950a8c9b5fd6dd1d6ecf09e98c3d"
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

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end