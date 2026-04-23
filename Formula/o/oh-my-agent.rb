class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.14.2.tgz"
  sha256 "42136cf756b2f94bab405b590bdb2a109322fff5972fe5af8b7b1ccb44de7b21"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30fe6f56d96e4934e117d7847a8ed441c093bd0bd455cc614d955cc505bd8d65"
    sha256 cellar: :any,                 arm64_sequoia: "05ccc3837b5329d88e223fa69d2aefa03cdd7c6441b1100bc2fefd0d6c4b92e8"
    sha256 cellar: :any,                 arm64_sonoma:  "05ccc3837b5329d88e223fa69d2aefa03cdd7c6441b1100bc2fefd0d6c4b92e8"
    sha256 cellar: :any,                 sonoma:        "7b1a8470b5c2e24d527c4debb0c1bb4d1149b36b6be19190775342264946ae90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b5d276fb64167c950686e79b8d447932825501bc91944afb6a5d77358d9f683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa8bf03294e28f3b2fdee2244471c230f4cbd6f9676a7a03c21d9baf268a5ec"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end