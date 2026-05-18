class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.14.2.tgz"
  sha256 "cecdda4d8f5da6e8f60c99962d2b536458545c56066bf32298b3134556c1bab3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55fd0fbe414d4c9f90986b1811911f69629be805c618c5d071bde5d837764890"
    sha256 cellar: :any,                 arm64_sequoia: "67e429a7885f6ff24064a0d9a352defadab67b6fdf71789671b0b858cd24c1c0"
    sha256 cellar: :any,                 arm64_sonoma:  "67e429a7885f6ff24064a0d9a352defadab67b6fdf71789671b0b858cd24c1c0"
    sha256 cellar: :any,                 sonoma:        "1646acad10836aa3f96d3da09e1eb74aa33b0f6ab986728331a2cc4c40195a55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084d9ab474b68fb61e5fa72b49d66841cab616f86cce2bf0476c4d2a76b7d137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c2e5c1b82f7c3220eaacefc2e01b6a11ab12efd91f6529654d8e7e8cdff19cd"
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