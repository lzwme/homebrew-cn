class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.14.3.tgz"
  sha256 "e5ff09abfb37297e3346fed022c29ea07becead9c8c729c4915b302b109e7fb8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "738de9d96aaf353aebf369e475471cb4e7e6af84605c6abf42e8d71146bf5c44"
    sha256 cellar: :any,                 arm64_sequoia: "d26a5db0fbbc9be0b2f48e7c1ab9403713d4ba00105d077db756eb57e1997af5"
    sha256 cellar: :any,                 arm64_sonoma:  "d26a5db0fbbc9be0b2f48e7c1ab9403713d4ba00105d077db756eb57e1997af5"
    sha256 cellar: :any,                 sonoma:        "623e3f1499777bd0290072f172c02b9e4adff0d4b007b76ed1f7c0c5ab8c30dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf90cb16221a20f935da9a0b6c05681266f9b6c2a20979e606942a50bcb7249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a32fa14f49b5dfa943831b538ec16f94e674b93c120abed2bfd5a5638675f2"
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