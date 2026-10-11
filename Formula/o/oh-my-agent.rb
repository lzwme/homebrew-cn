class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-17.1.1.tgz"
  sha256 "2d485e5953c4cffc8e4cc441dc21150ab1569c0af83731dfab8bf80d12777e85"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e9544f6b6db797a401c24aec613bbb500cc5778209678707672900d677677ebe"
    sha256 cellar: :any, arm64_tahoe:       "363b678c6d7b6489c1187b126e2362297fc3861b6b0a5b3ed584db4a205eda33"
    sha256 cellar: :any, arm64_sequoia:     "e0c6247a98b74a22873612e5d6693b82ff8498ed54a4ab2f2855110815081cde"
    sha256 cellar: :any, arm64_linux:       "25a34d03cc83ef977852f073c624a22dd23a59957884a502f3358c9375b3c110"
    sha256 cellar: :any, x86_64_linux:      "af81d0c4b4c26d75054812d72e9311076fce4afcf6eb2a98b7d3584a5b0f4f2d"
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