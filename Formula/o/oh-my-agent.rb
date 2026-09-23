class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.14.1.tgz"
  sha256 "3bfaa6288889d5f919e0d49d0b869d9f045f4a890fe7314785ba7b29a9f6456e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "58e00e16ec5576b8534030ddbcfca90b5b8168df5dd498e680b0c94d1ea7c8a2"
    sha256 cellar: :any, arm64_tahoe:       "0a4c490455f0afd6838600e66432d60004d8c9c84b2bc470c9e617dcde5a7cef"
    sha256 cellar: :any, arm64_sequoia:     "f2661a6f95e68f49b80177db69478df500f500606bf3f68701cbe5e7de3c0f68"
    sha256 cellar: :any, arm64_linux:       "f1994f5ad6d30bebdcf58933451643c0e2804039fa2809c589007d566c6c43b8"
    sha256 cellar: :any, x86_64_linux:      "0cb248c87f40703daa1df7f320625dd773440d575b15b50a84de7bf41d08c95b"
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