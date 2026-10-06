class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.1.1.tgz"
  sha256 "d98717f8c11d6a922494e6a04cdcb803059c03f26da59edba29ba970e2dbf8cc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d1af51aae42f9a0048936fed9c74d27b0166ad6b20f45aaeb20eb9e070b1d7b1"
    sha256 cellar: :any, arm64_tahoe:       "1a712fbfa83fba232a0be4efe8967a2723718212576c4c4a01058faaa697a56f"
    sha256 cellar: :any, arm64_sequoia:     "3a47152aa86c86d0286ae68c61b2386e680e7f95160e75c0f07c57da27b39b48"
    sha256 cellar: :any, arm64_linux:       "80ec042badd834de169ee4a25da2b15022e64d9f79945fbca0bf24a8c09e4782"
    sha256 cellar: :any, x86_64_linux:      "efe071379ed911cd0e9cd719c00377e07ef1ab13b41157cbd8f769f3fecd10fc"
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