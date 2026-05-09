class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.16.1.tgz"
  sha256 "860dbe10409fb5f2c350024b9121bc54aa05b8d05ab6568f5f92f134263a7cbd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "450dee96cb7e681d1421e798de820e1e529a947289f12662f18437b5e791ef4b"
    sha256 cellar: :any,                 arm64_sequoia: "4ad999db42a959250ed8a40adbbe0b8e3b8b972d3132f04ead33bdf16dc29569"
    sha256 cellar: :any,                 arm64_sonoma:  "4ad999db42a959250ed8a40adbbe0b8e3b8b972d3132f04ead33bdf16dc29569"
    sha256 cellar: :any,                 sonoma:        "620dfa41f60993132e4ab45cd9f85d3514680f97c2f71f6730a94e62ad17fc0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77e0abaaeb60cc45b0ae7481b566d802e7710b34e0f0530bd27fb7e704da3c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd6db1f6d7f73955ba29d2f7e77c66b7c8220c3fdb0faaea1d725b40c88386b"
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