class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.12.2.tgz"
  sha256 "848335fb84a9e7302c804fc927e65d37bce2f06f3d0bf29450a04eb3fac6a08b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76cea67fead988b07ef2d466020c4bc09392420c1402db44096b93df8147c570"
    sha256 cellar: :any,                 arm64_sequoia: "3b665e7f7931fc402babd51d63bdad1da44cfbb561b36fe2b48768a26750d7db"
    sha256 cellar: :any,                 arm64_sonoma:  "3b665e7f7931fc402babd51d63bdad1da44cfbb561b36fe2b48768a26750d7db"
    sha256 cellar: :any,                 sonoma:        "3d3cc4fc106dcc51fc78e3e9192671e59cbacb7d18759abab07859ab29d13076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bcf92faea6afb8ec79df49d0bfd37d672931a0d5b13bc4873ff2d9e52355040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4ee8dd5719ec7633b4a1c3760ad64616b68a647bc08e830baa46a0e507c1f1f"
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