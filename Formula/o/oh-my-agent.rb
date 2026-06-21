class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.3.1.tgz"
  sha256 "24f78d11eca9b916c933a964419b7c2989ae725ffec6ffaa9d7098d9086af1b5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d3f025314f1fbadd2f2d1ca5c2676b3fee7e3dd8ebe2f3dc97258f8cbea2f6fd"
    sha256 cellar: :any, arm64_sequoia: "968ae2f486fb2cfefe091803cc036b1a212000d96db6532392500d191dba8cb0"
    sha256 cellar: :any, arm64_sonoma:  "968ae2f486fb2cfefe091803cc036b1a212000d96db6532392500d191dba8cb0"
    sha256 cellar: :any, sonoma:        "c7adf7bb634f3ea0a066ab8a64496c6dd27d5546627395baf1da2330a250f4af"
    sha256 cellar: :any, arm64_linux:   "e96d7bcaafd85eb4b682ad87448e67ef3a82000f3fd904f01074377e08215936"
    sha256 cellar: :any, x86_64_linux:  "b7640d8badc00dcb0b9d7834da539dda28d89be0f3c220ec125fd7b6c6fa1198"
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