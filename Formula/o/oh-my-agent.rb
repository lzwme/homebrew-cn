class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.8.0.tgz"
  sha256 "a2eb6dfcae6e3ed27ebd789065c5b0ca45da5a792edb8140ebfc1c21e46ec45a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5cc9ab378b8e79ca9c3d7f715efa329dd0f993bc82f692d3fc875b8d1d1bd5c1"
    sha256 cellar: :any, arm64_tahoe:       "a529cf21eadfc6c241ea579c435cd3a7e9cde43ab7c48473517152f1880eecef"
    sha256 cellar: :any, arm64_sequoia:     "2d158ee8d762e7d78c7c3138c17f1f6ba4cebf0bbf1aa57f672063b73a2c920d"
    sha256 cellar: :any, arm64_linux:       "e7066ae09b5c1df2eb3ef43661eb8f30ff29b2547e7f2259ba3555bf9e209846"
    sha256 cellar: :any, x86_64_linux:      "0ce579602f86fc2e1e63285c7b655f61b9a6d5e47c769fde2ed73a0ac811facf"
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