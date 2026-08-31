class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-13.0.0.tgz"
  sha256 "f1cc6a3a898ed7f8d3e3246cd832c8d1a35429e88489524e6f68334323453593"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "949e0be5710246b4c143ca006b671dc6cfe364f66af66cc5b8189c1af20b9c78"
    sha256 cellar: :any, arm64_sequoia: "0861c7c046dfe85391bcb63e07e22b129854a921d317368df28d00f5b9378c5c"
    sha256 cellar: :any, arm64_sonoma:  "f047e4ffa2d12087f5fe54429d8396c0f1920528db84c85643ad30c7dc304f50"
    sha256 cellar: :any, arm64_linux:   "ec6260d709c77e7f5b562a7e9b7694dbf6394315843b880b031519cec24c853c"
    sha256 cellar: :any, x86_64_linux:  "7c89f75a4479e72bd7175941275a9be6eff06d07197d5cfc11aff1d29e537d15"
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

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end