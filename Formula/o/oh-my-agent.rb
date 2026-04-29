class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.3.1.tgz"
  sha256 "f2ec5e12898ab4d52ec4dee1f287a444e87cad11766361f7fd3c492f9c48f94d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9069e652d05489f47ccf44e7991ae4d9c135e1a68122338bce40bb07baf4b4b0"
    sha256 cellar: :any,                 arm64_sequoia: "cfdfd4e8fac4252e024f2a6b7b24145a8807eb8e4f6ea536586ede869310ec36"
    sha256 cellar: :any,                 arm64_sonoma:  "cfdfd4e8fac4252e024f2a6b7b24145a8807eb8e4f6ea536586ede869310ec36"
    sha256 cellar: :any,                 sonoma:        "1551c37afd068509e4a5191998f6696f72a8b8d0c7e464f06e7dda2e2075558b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c10cce5c1f55be039361d1ea08faa27025080dc70060563d92a4580d5376ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d710f63746d0f7b5ebcf0791358abf5b70c0bef34b4482279078430ebc4c65"
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