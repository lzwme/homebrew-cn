class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-19.0.1.tgz"
  sha256 "f1d86a6cde4633dfe5baa010505f38ca8ab2e6dac6268152d6871c3c79381110"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e61db48e5c51ff55a3602dda737c940b67a416ce47cb4eb2f564706a18d3862a"
    sha256 cellar: :any, arm64_tahoe:       "b5572e56d03a802677839284c5ba8a89313c657b85716fff503c8fe904955b02"
    sha256 cellar: :any, arm64_sequoia:     "3ec68850627d25478cd1dee0d5752697f818bf2b1796e7ece101314a75cc6480"
    sha256 cellar: :any, arm64_linux:       "842f64734fc6c3fcfd67623eab668cbbb4bcca6f8963460ef48102d94252c70b"
    sha256 cellar: :any, x86_64_linux:      "9ab9e5746015e58d1b4abccd6a4413817d166eda56f4e639dc0a087f06f8d5b2"
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