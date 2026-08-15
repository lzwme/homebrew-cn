class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.2.0.tgz"
  sha256 "c907b9cba028b55fb2a8c524a31fe8580f53efe8ee7a6a2c4e031268dfec38cd"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a09e2027fe82e6c50fd6412680bd5f45d97465cf9794c214a4a6d533d05a99db"
    sha256 cellar: :any, arm64_sequoia: "aaafd53aaceafd1dd214fb1e764a140d5e4c70ef2ea0b017d2234c6cf32b2dfd"
    sha256 cellar: :any, arm64_sonoma:  "aa436bb1e97f9c83fb7d90435cc4046516f15b2fe741a9aebad3235d752b6614"
    sha256 cellar: :any, sonoma:        "23ecb6b4cc0b82fd5c948fd8951f4bb22bce1751d52c4164e1f0a51733be2ae0"
    sha256 cellar: :any, arm64_linux:   "ab3cc872d1d4f14eb74e3eebc00a141c90e3a916b82a44132155812df2fba5a9"
    sha256 cellar: :any, x86_64_linux:  "83c9c5ad002f60630df6b3f84bcf9e9d0180042e02f000059bd5305d16149842"
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