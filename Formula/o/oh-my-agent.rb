class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.5.1.tgz"
  sha256 "ec5a6df94b9268da9c257674b539afdeaa6bf75ea154767133c7cb4e061bd6b5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca668137a584da54e710a16daa266b2d2b98876d9378533e15cfe991dec62f64"
    sha256 cellar: :any,                 arm64_sequoia: "f1ad7920521b1cf674836c0488adfa5a22b9ea5adf32d09a11cbe218f3efb564"
    sha256 cellar: :any,                 arm64_sonoma:  "f1ad7920521b1cf674836c0488adfa5a22b9ea5adf32d09a11cbe218f3efb564"
    sha256 cellar: :any,                 sonoma:        "98c364a35be3deb3d9e9afbb8e120837b7251f0afd14291422c9251fae6d1cad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4065d5eb12afba6009d40966172d8b7798f8e41f3ad43de427f5bcde3887bfec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d73f44cc4abc1e4fed2e7eb907d1c331e92df82d5fefb794af080e137a5aa9a1"
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