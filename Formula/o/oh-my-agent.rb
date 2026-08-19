class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.4.3.tgz"
  sha256 "266636830c6f99c5d8a737497f4c9ab5e6cd71bb25b4613970b2eda5a86ecf4e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1dd7609e97643b826e42fe2bade7b878aecdd65383ea2d9b86dc91afaae2a952"
    sha256 cellar: :any, arm64_sequoia: "b910a3fdf24d2ce7a30d7fb43ace21edb499b9560d76b443767f8d85225700d1"
    sha256 cellar: :any, arm64_sonoma:  "31f7d00be5b683e1ee02df66114e465678f07ca33f5b6278dc8940e3ab51f83e"
    sha256 cellar: :any, sonoma:        "55d164465902120572bda146d21ee652c9974dfc53947355ee06493498fafef5"
    sha256 cellar: :any, arm64_linux:   "81e3e89acd7b5dc595011799b56258eaea8b2cb0b6934661df7aab1fe8aa4080"
    sha256 cellar: :any, x86_64_linux:  "e85eeec4970e572b0abd7d41c5c207fd96edff49c59d954b4912b776555e96fc"
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