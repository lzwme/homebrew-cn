class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.10.4.tgz"
  sha256 "a60a3f9e284e94171e4a30eddbf2028a633697254bccebbeee0895fd5e9e037e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c433181c2fc6a94efc4bb678f897d55ff52863a6d18854de0e5d5e9317f84404"
    sha256 cellar: :any, arm64_tahoe:       "1b7e1c962d58ab15c08d22ce9624e7a62543b01c3b40d2c3908e15c50f0b465b"
    sha256 cellar: :any, arm64_sequoia:     "820ad0f346d91f23f1566b88f7bddddee6321191ad0f62f6b3bdc1128f9a62a4"
    sha256 cellar: :any, arm64_linux:       "9c5d27e66ff7bdc06c396427eb8e273ebadfe1d94fd11db5711c6b24fdcf2ee0"
    sha256 cellar: :any, x86_64_linux:      "a431f5dbf1350462f2d7929d31249ea475ff4bccb085f74577654a18331fa38a"
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