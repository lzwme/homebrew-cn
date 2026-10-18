class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.4.2.tgz"
  sha256 "dd1ea1a9cc976d9dca4bc692bad862630fc7c2947e1391b61e738a9a9e87fef0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b89b07fc0e64182c4eaf7a39356c6b0db6c974b59dc34ed6a0f712c8e20bfbc7"
    sha256 cellar: :any, arm64_tahoe:       "228b9b9851aed4cf135f63bf60984641f0ad3a61d41bfad4785072bd37af6a3f"
    sha256 cellar: :any, arm64_sequoia:     "c7725992a76d0535998d359098b60b3c584607dbd1cb5581dfb335f079e8041f"
    sha256 cellar: :any, arm64_linux:       "33834906c634d5025df90429c540d1c36e9b8cc32aeb4ede7fe18943a01ba03f"
    sha256 cellar: :any, x86_64_linux:      "5322238390cb5ff1c4e1bdc8e5b07d79ba09e7b214d3fe86b83476f01472f570"
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