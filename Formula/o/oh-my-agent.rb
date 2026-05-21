class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.23.2.tgz"
  sha256 "2d560a8ace774d53a768e40ac1e57166ffa0ffbf0f93be64eca2461f71aaa7ed"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a567e1f704bf7cd388b31f5c4ad10a515e70f802379d2b9e517fb594465d0f0"
    sha256 cellar: :any,                 arm64_sequoia: "5754af1bc3f76ef978bed3e98de10b429c2876f81a3a78a8375dceaddca8b13b"
    sha256 cellar: :any,                 arm64_sonoma:  "5754af1bc3f76ef978bed3e98de10b429c2876f81a3a78a8375dceaddca8b13b"
    sha256 cellar: :any,                 sonoma:        "9bec6a20cb8974c0ddf283372dc0a3ba13a8a2b35b88e4cca936424bd7faf732"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fe790db472f9f545e8a59a6137779f08e6fa7fa570f9eef44a2c7b8e39b8173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86fd666825010439876fe866346bfb6d81e714e9a9bc47a6448a4f433d8636b2"
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