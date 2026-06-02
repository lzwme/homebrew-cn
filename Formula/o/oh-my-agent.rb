class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.21.0.tgz"
  sha256 "07daed6b8c3b14e97bd8c2615c63f5a584f6548405657ccf6dcb8e44156ccf29"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b84829a35c71a487ff6f342d97a87ae5ae24239b05dbf51f8f9bae77086dd889"
    sha256 cellar: :any, arm64_sequoia: "101c22c2d14d4c48fda6adac975a6ee3f3dd145250c2ead928a49b7e5fa84090"
    sha256 cellar: :any, arm64_sonoma:  "101c22c2d14d4c48fda6adac975a6ee3f3dd145250c2ead928a49b7e5fa84090"
    sha256 cellar: :any, sonoma:        "846877b24e47454c336e1c0d3053cccde56f9ac32771d3c3287289f87b1850d0"
    sha256 cellar: :any, arm64_linux:   "85b7554fcacf154d8ba5c6399f58446e7e7f6e153d0b116d45b12d6a29638e3e"
    sha256 cellar: :any, x86_64_linux:  "f4e7e9fd223fae3c36893b021ad201f53b5407f79b927c4366037a5c35206af5"
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