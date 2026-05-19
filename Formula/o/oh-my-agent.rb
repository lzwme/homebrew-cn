class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.20.0.tgz"
  sha256 "9014bee59433d492fc997cbbca97ea8975575b8b3431e2c15fbf4a49c64f7f8d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5528ccd0966a19576152ac04f6fef70004aaa1d7aafb58d5e5121e6ea249766"
    sha256 cellar: :any,                 arm64_sequoia: "543c09e3f2e320a4237adb6a7c499a920425cb3b317890048fb46506b59b79d5"
    sha256 cellar: :any,                 arm64_sonoma:  "543c09e3f2e320a4237adb6a7c499a920425cb3b317890048fb46506b59b79d5"
    sha256 cellar: :any,                 sonoma:        "86537e4bc1f41993b61a7a35f412b727fe28ec5a8533a8201d5ae6f9c36667c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f653a810c07b0c0653ea46e3e98b9e17b116099d1c6cdf3e32d432f259346b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eafdd542facfcfa00f62c4e7fead3465ba5d3cb92602534b40c8a2009e6eed49"
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