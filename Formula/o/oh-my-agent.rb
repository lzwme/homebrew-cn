class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.18.0.tgz"
  sha256 "044ee5960651125b4802d5a29f70dee96f6d125150a29696fe4b4bfdee130bd0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7168cce3e9f2605925442ca808c80fcf1fbc9f072c63be5ab3640600075ef280"
    sha256 cellar: :any, arm64_tahoe:       "51d67c618e35774e2f6e671b0ceb02a02b773dce103b3e4a8971ac3cb16054f1"
    sha256 cellar: :any, arm64_sequoia:     "892c868e4c5a1396083510393c8c103f291c07e31dbef8283f7e1e3ed4fcb4a2"
    sha256 cellar: :any, arm64_linux:       "fc89ec06b0d99b671cfc241080ee04260df5694b46050173409bd98f087ee8cb"
    sha256 cellar: :any, x86_64_linux:      "83b787100a821d8f81d35b49c3a83741f9930b813c4cac4c7e2425d2dcfbf450"
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