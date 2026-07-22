class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.23.2.tgz"
  sha256 "6d5d91aa9a1013f6ed73847c9fa292cf0fc18ee42c8e452b0b9aad58fb5482b9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0e8af1a6f6f09966a0c2120e97df0303d350c96a375112464274204e7bc9022d"
    sha256 cellar: :any, arm64_sequoia: "0e8af1a6f6f09966a0c2120e97df0303d350c96a375112464274204e7bc9022d"
    sha256 cellar: :any, arm64_sonoma:  "0e8af1a6f6f09966a0c2120e97df0303d350c96a375112464274204e7bc9022d"
    sha256 cellar: :any, sonoma:        "ce0619304e956390565046a043554f0a1a321b3e3c8cb709a45a9971a01d14a4"
    sha256 cellar: :any, arm64_linux:   "1b95d3ac817f592bc083e9f0c70c6a935be294d9515c062b3a367ffb67291e2c"
    sha256 cellar: :any, x86_64_linux:  "fcc358d7b744f6d1d9f77aa2ee59b9c48a514edddf31a115164a418a2288ded6"
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