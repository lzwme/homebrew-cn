class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.23.1.tgz"
  sha256 "57ad5b03ce96bd83977f8edf348907a8055d74691c8cfcb8780e17676aa8afd2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bbe86d4601c65f38fbec7ad31773cbd4894effb13ec098f02cea895accc756fe"
    sha256 cellar: :any, arm64_sequoia: "bbe86d4601c65f38fbec7ad31773cbd4894effb13ec098f02cea895accc756fe"
    sha256 cellar: :any, arm64_sonoma:  "bbe86d4601c65f38fbec7ad31773cbd4894effb13ec098f02cea895accc756fe"
    sha256 cellar: :any, sonoma:        "57e1301b1675249641184f74e8651178c36ac62f6c289428952a32371fb574ae"
    sha256 cellar: :any, arm64_linux:   "a86ec094dc4173641b878e3843dd5c2379a62a07b82841cabd57943526d97863"
    sha256 cellar: :any, x86_64_linux:  "8a407cd1dbf38d0d65e5373d424e958dffe50defe59bcda63e74bca322c9f99c"
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