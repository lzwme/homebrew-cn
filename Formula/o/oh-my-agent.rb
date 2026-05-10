class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.18.0.tgz"
  sha256 "0bb6b4de83b7cffcb4302e31cdca1b32b9a152bd9c5ccc3c796c327f82522166"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b333c04de56db53d1e6e0f7feaca74c4eec4ce8137d8886198ee5c6f6606a49b"
    sha256 cellar: :any,                 arm64_sequoia: "463d399cfcceccaa0a5801b62c596fe1d788556d6a0de40f908f1b743d4f1e72"
    sha256 cellar: :any,                 arm64_sonoma:  "463d399cfcceccaa0a5801b62c596fe1d788556d6a0de40f908f1b743d4f1e72"
    sha256 cellar: :any,                 sonoma:        "280777d7cf0830d3ee0cb4ecf4de6364d8c98bac4b6ccc7c1e66aff7b8741621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76f7842d079c560aa1aeee3fef360b94ffcafe63be9be7f7c7a56ac2b78f0720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "710dbd9b1a721b94c173bc9adbae4ad5cb7340352086b24f528a71856c18a61f"
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