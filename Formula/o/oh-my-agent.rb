class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.5.2.tgz"
  sha256 "c5d57f16b4c2024614ed478c0fa6d8abf04c92386d3c0a3c4e308f6a3d841a79"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b0c19cb2aa0181bdf3f8babed73d6b6b0be9d655468aaccb770846128d7ca08b"
    sha256 cellar: :any,                 arm64_sequoia: "ca6787a19b4885daf14cac6decce1dcc72b2206aa1fae076787880d08edecbac"
    sha256 cellar: :any,                 arm64_sonoma:  "ca6787a19b4885daf14cac6decce1dcc72b2206aa1fae076787880d08edecbac"
    sha256 cellar: :any,                 sonoma:        "eb5979b0475a65754388cffb561a8973e441738b7beae147b5763c7a925e4f56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f874cb19575460c0de6008e9025fee0d18a21854b351b41a2c2637f929d0770a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d15e4b10dc96cb85fe84bf781c1cf1e3c0dad7f2875fbeb490431f4c947ac54"
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