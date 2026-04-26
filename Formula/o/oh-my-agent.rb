class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.20.2.tgz"
  sha256 "d16b2bef1fa1eb74249a11e0c11328d9fa0c0e56f3607c5c9f1e09ef24bcfede"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25f113e47a14d9e1858814ef99d8282637a37bb5abd4d4da65e9adbfdc51d0f0"
    sha256 cellar: :any,                 arm64_sequoia: "9429cadbbe16db7e7adf0f35617263fb1069acb7fd1efbbd2c3acaffda5d0aa6"
    sha256 cellar: :any,                 arm64_sonoma:  "9429cadbbe16db7e7adf0f35617263fb1069acb7fd1efbbd2c3acaffda5d0aa6"
    sha256 cellar: :any,                 sonoma:        "f4acc36e82cb755e01dcd714818fafa8dd74ac2711023d1a79a57c5e975553e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd2e630e6ededc110df05d3b9f1608b9bd8a004964c0ebffb72789d35938d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12260d320d3203c8dbc8a8749058690435cd55777fc0932e2d7a9f75269e4d53"
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