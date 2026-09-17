class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.12.2.tgz"
  sha256 "b229fafbb098686fbad9b763c1232ff92486181b10e932c33325191cda5c2012"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e7363cf8545b93f8f4ac45553f2e0517e1156298205be95141b683a04994a9b3"
    sha256 cellar: :any, arm64_tahoe:       "66051e20cce44baba4dc15b0adba396a5b24293bdfd510e26659ec9ea5cc4db3"
    sha256 cellar: :any, arm64_sequoia:     "7a317b1f4fde6ef5b1086be9f00cded1142abda41a6049194737084b071f842c"
    sha256 cellar: :any, arm64_linux:       "86ff9ffef0d7011679776140437a7a5e1a9d520b707e973c7fc2f80407a77e26"
    sha256 cellar: :any, x86_64_linux:      "800632b9bb15237208270d48172bcc11cf7fa782b1fb05457bd6edabe27f1624"
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