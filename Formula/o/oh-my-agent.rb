class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.5.0.tgz"
  sha256 "5f691291801b8de8a2ee06de82a75883e48fe48320af0e8b299625f051bec488"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "788396bd061a7ac685b13cde07db63fb5f2d1b3d1762b351b96efb1b0170cbda"
    sha256 cellar: :any,                 arm64_sequoia: "1ae24cd3548c4bf403c5e254303ee87b7c04c55745b1f2204ea994a1975ecf6b"
    sha256 cellar: :any,                 arm64_sonoma:  "1ae24cd3548c4bf403c5e254303ee87b7c04c55745b1f2204ea994a1975ecf6b"
    sha256 cellar: :any,                 sonoma:        "f711f61fea006de8605de06cd670e3fa60c4b369d571f96b306be01ba4cf9e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76fd7974aea267476004a8e8d184fd57cd2d93afcbb5434e6a1659f170e800b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9106699929acb66a6c63912979676c4bd1cb6bcb2b00b3928b92cda8f5bfb6ce"
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