class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.4.0.tgz"
  sha256 "bf608f310a5a3b7c13d29998bea56ab7b4a53729172836c73dd5e341a9ad8e1b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "18d0cc6f71637aab8d8f15a59b0d10eb00f6f2f50e6f8ab3a2c13d62f6ffa982"
    sha256 cellar: :any, arm64_tahoe:       "2c62c902d2db791525c6fbe487f36fccc4f951010122a2766c62f194c3d9cd93"
    sha256 cellar: :any, arm64_sequoia:     "09cb4bd3c1a6621729666bde6fec245128ad5287b06487147b76599f2e7d29f5"
    sha256 cellar: :any, arm64_linux:       "cf778a1a593051bfecb476885e7d60195258c040de4c11f38aba202323bf2f4c"
    sha256 cellar: :any, x86_64_linux:      "bb147030dbe181246903276a08f9ad9448da3ad98cc26f1b1dee62b878d9e060"
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