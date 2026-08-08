class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.9.1.tgz"
  sha256 "cf8b02fd323a77c74b9aa96a8fe401834bf03ebbf9c902e217da8309f63b9781"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5ab4852eb380b32d9a2e9426646e5f8da6ecdbe61fc6e424fbbe2d504418e63c"
    sha256 cellar: :any, arm64_sequoia: "415bbfeed3d8a347ed5fdcbef23fc20044946b3c9f5da2b4f2f4b023e1263cb1"
    sha256 cellar: :any, arm64_sonoma:  "1ee75f73166fb28cb22d625a1936d84ef95d58c2c37a9b543a1d76e2263f3305"
    sha256 cellar: :any, sonoma:        "5d20aaa70d60352bd64092f1a23fea9ea80dc4649614ad9406dac7e1973a081e"
    sha256 cellar: :any, arm64_linux:   "be26f9163d3c4cc404014d5457ad710b5d9410a4f2334d4b956d8a05f34380c7"
    sha256 cellar: :any, x86_64_linux:  "26a6c5ca14d3a430f21fffe9aeb73cfc024e98388ec055913d6226d4e9e172d0"
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