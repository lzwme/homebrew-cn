class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.52.5.tgz"
  sha256 "0134dcafe84129d57a0dd6437ccaf32d71384835508cb61cdebb24fd0e4e4587"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e7c25d5a581153e960f9d05ef004f0b33508d3ab69d30ae490a3ff9287fc4207"
    sha256 cellar: :any, arm64_sequoia: "432f187edd9829b554586acf8149e7da262473b6ee56fb8211a787507c41e245"
    sha256 cellar: :any, arm64_sonoma:  "432f187edd9829b554586acf8149e7da262473b6ee56fb8211a787507c41e245"
    sha256 cellar: :any, sonoma:        "6800cebfd2ebdd48aac1be9804c2bac80e4616b9e259bc23b5f3f526fd6c7cae"
    sha256 cellar: :any, arm64_linux:   "e1bc14d8ee9e67ef81575d312ce4c0b6b9a4984f8ed954cc4f7e7ffcbf17ad88"
    sha256 cellar: :any, x86_64_linux:  "8f689ad565de0749c5088ef3705cff20ab519eef9bab7f1ef7ce794be79a1e5a"
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