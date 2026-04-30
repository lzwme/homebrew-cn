class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.4.0.tgz"
  sha256 "d650b4a2415869540b91f0806ba4576a0d6511eacf8e077fbbd8e1ec63e3fd99"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e858193da4b0c4d84aa379c77564a4c0510c300a8aeeaf9e22ac903a279ebf40"
    sha256 cellar: :any,                 arm64_sequoia: "4917229410faf3b177067a93790b56815e0a14bc001599046b72c075349b4211"
    sha256 cellar: :any,                 arm64_sonoma:  "4917229410faf3b177067a93790b56815e0a14bc001599046b72c075349b4211"
    sha256 cellar: :any,                 sonoma:        "d93011448ff090fdfbe7aefac05130b75288ad2ca3e3041cb688f7771efba6c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3323c2386f0f7c3227a4ba34e5e9cb59e5c26a650e21d385ea29a4de4782433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e324fb72dff876ece7806dbb147074690de023dbcd4eb8f232f0e9c2b8836e7c"
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