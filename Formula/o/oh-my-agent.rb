class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-13.1.2.tgz"
  sha256 "e3c66fb13c7327e3ae6386fb427de21d91c03c981b854b689c5ce71b919d13d8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c76337677d9f0d7aa93f0a733daf6a5ec3b95bea7a9caa1d3a1cbd7b273f356f"
    sha256 cellar: :any, arm64_sequoia: "e6bfceb6173242be33a61dafb577865c8bd817876ec237caa0a7ab9a216735d5"
    sha256 cellar: :any, arm64_sonoma:  "85ce607866eb22bf1b0f8f8f927db029fc53b638ce453e925acb36a49264e537"
    sha256 cellar: :any, arm64_linux:   "563c944061ec1cf2ebf855070a9cfe7230987b50f0ee1dea634a589ae10edfd8"
    sha256 cellar: :any, x86_64_linux:  "b86674e379c2208e79d84720a1423712512e6963d386202a2e7395a98388a215"
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