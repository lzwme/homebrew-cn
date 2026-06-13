class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.53.0.tgz"
  sha256 "07d43ed0b707fcadb6558075e4b6961ed960811d42d1229cc11d4ab74d065bfa"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "10b127285ec5b3d3b188a31346fc16a8ed6093d3d381a4e566c240960babfdf3"
    sha256 cellar: :any, arm64_sequoia: "382a8ac3100943c9096445b59a186a70fbbf8e3533f16854e759fc41dca69532"
    sha256 cellar: :any, arm64_sonoma:  "382a8ac3100943c9096445b59a186a70fbbf8e3533f16854e759fc41dca69532"
    sha256 cellar: :any, sonoma:        "ea4ea44e0cd593942544eceb87edb10d2dcfaec1a3a9523aede3dab21ab87cb4"
    sha256 cellar: :any, arm64_linux:   "3e94307445062f3b3eb16b51691d009360b3266672667e69939d7797c28605eb"
    sha256 cellar: :any, x86_64_linux:  "3758714d5cb2a6b774614bed1811d35a10e4aabb878d6ee1aeab9f1215ccf154"
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