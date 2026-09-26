class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.0.2.tgz"
  sha256 "2c8bdc8431b3e1638ae48e37f5a84ce65dcf448201ac76c5da485b6f91496f56"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "663422bb1a030678f3310d56047dda8c25ec4ddce5ac33d41f343d7de0f21984"
    sha256 cellar: :any, arm64_tahoe:       "d24da62e658e5195f436f2b299c6459a8cbb0c9aa4f7f8a3ef9c9fb99f72d22c"
    sha256 cellar: :any, arm64_sequoia:     "0b96d1b0d1b85afb5f722f2ee391ad2d142e5c46d1593ad82daeb29c7c22b435"
    sha256 cellar: :any, arm64_linux:       "4c20c8610422ffa1075438a62d4cfe5608acd316e0c038084d57e5dc821c7353"
    sha256 cellar: :any, x86_64_linux:      "66ff758631fee28a15da35517c6d880d26d4bfea344b59e599d6af099302c2aa"
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