class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.19.1.tgz"
  sha256 "2296cd117834f17f967d0ffc18f31fdc9fc1b6cd438e1a1ae2945540cd8d1428"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d64d88f693008e69967adadb3a500d5d8984264003996d94c472b0f00df0b9f8"
    sha256 cellar: :any, arm64_sequoia: "9177d375a15d591a40eee5bb0faf5e1640bc30d55dc055f86145a8109b295dc3"
    sha256 cellar: :any, arm64_sonoma:  "9177d375a15d591a40eee5bb0faf5e1640bc30d55dc055f86145a8109b295dc3"
    sha256 cellar: :any, sonoma:        "78738374743cbdaf794e7cac8774c1ea149e9fcad574cd091fb97fbae648b5c3"
    sha256 cellar: :any, arm64_linux:   "69ecf85fe5a61f5b49a2e5852b175ba5d0c7564ff48ba1851e2c669be1576421"
    sha256 cellar: :any, x86_64_linux:  "b22e1fb9963c09166c9f5d653798725bdfff6a98d4fce28e867247cc14ddc45a"
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