class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.52.0.tgz"
  sha256 "2aeda1fab2e332f7b01981956099a6e3c444f63467489b92ece97d82527a9ad9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c1ba5d83518930c9b93538d511d79c21fb1c048c9c3a62edee1460e122ed96cf"
    sha256 cellar: :any, arm64_sequoia: "cf9a8ebb1d735d1a760315ecf7371dfe513560e322eee39bcc900e2bdcd9a10d"
    sha256 cellar: :any, arm64_sonoma:  "cf9a8ebb1d735d1a760315ecf7371dfe513560e322eee39bcc900e2bdcd9a10d"
    sha256 cellar: :any, sonoma:        "c084790f2fa7b2a422f7b80bdfee96f442832b84ed8bf61ba2da95bb1efc0df0"
    sha256 cellar: :any, arm64_linux:   "6be37dccb3e2b0e64a33d0c6892029a4b58a094ce861fe1f008fead31cdab2b6"
    sha256 cellar: :any, x86_64_linux:  "012c70891d2b5700285554c19421296d858136565f75aeffbb63678584b42a62"
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