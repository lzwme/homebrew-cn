class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.13.3.tgz"
  sha256 "dbc06d6f7801fbc90aff21be344a26db003fb1287b2714d4f73e9db5293f9784"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b184b4fe9acd208eefa4cd1df19d44d9478fa539041d52027f72974561541e95"
    sha256 cellar: :any, arm64_tahoe:       "6e794faf27596ba636ba933211609d0093405ea44a1bcd71174afed47bfac36f"
    sha256 cellar: :any, arm64_sequoia:     "3004523da34b22203f26814ac89fedb0b626be66b77aefb7971ebbda3ee7031a"
    sha256 cellar: :any, arm64_linux:       "084f5328516bf238fa5797d7035325b97f66b0c46bd1c9e89527468b0b958217"
    sha256 cellar: :any, x86_64_linux:      "22f0264c2cfdf69bbcd2790b0db2f54bee80cccaa64bef46b763923e925cd651"
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