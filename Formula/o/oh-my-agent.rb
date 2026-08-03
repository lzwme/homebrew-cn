class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.5.0.tgz"
  sha256 "8a7ccd96a06c0b8e9958554e86713db1e5b8738abce5e3fe3a9b12d7d516d0bc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "23c912202e83fa897ff142666293c7e6673dd642f02e0be124433598f22cfb4c"
    sha256 cellar: :any, arm64_sequoia: "c05fc460d626b018c5140d8acbb9d53b086d5de90324cfd57221ce9b14f3e636"
    sha256 cellar: :any, arm64_sonoma:  "0cf341c649c12fcbec449b839e66ada1d8ded335b5e979e17559a8c490448d4f"
    sha256 cellar: :any, sonoma:        "938ca976a3abd99a00b99c7c2ed02ebff98bbf7a660d9bd527466941f5ee79fc"
    sha256 cellar: :any, arm64_linux:   "8ebe760e59c29ab70d0cd3553022cea9c3913946704217850c0c2ea92c721e51"
    sha256 cellar: :any, x86_64_linux:  "841481a091896054a69baed1056a46011d4b24c6e630971955f76bfb2c03e47e"
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