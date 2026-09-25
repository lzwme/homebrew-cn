class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.0.1.tgz"
  sha256 "3e6c5fa229e0b48598bb2febfccfac212a3a38805e9cb540300e381e6ef9b010"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f97d92b91e5358b588c64dd3f1f1a68dc636144d959d8a649ee6a105eb254d74"
    sha256 cellar: :any, arm64_tahoe:       "c36735059289e2a28d958543a1a4bc5607fea73ceb38a4624cec3b5a16150891"
    sha256 cellar: :any, arm64_sequoia:     "8bda6a00f338dbbdd5c0952862a0116824d256ccd553863bef7ba4265a4a05e8"
    sha256 cellar: :any, arm64_linux:       "6535dbec25ae1d59fee799d22e9e5f8d3455a2329fedfc44fe68bce4e8ebc55e"
    sha256 cellar: :any, x86_64_linux:      "518fe3d98db9d22021261254cde230812cfc57c706265df7e4917b89d84034fb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end