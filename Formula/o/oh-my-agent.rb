class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.22.0.tgz"
  sha256 "d4c1cbdbbb4ef7830dd2dac674811f3d812146d0618a6aa6c9e3e2facc58a280"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "40b29acac9dee81cc11b7be158feab8987d2cddec92e5f728815d099af744128"
    sha256 cellar: :any, arm64_tahoe:       "172c2cf09bf34e7db3178256dd6839a6c6d57f04f70f4a01609746a3ff7ea8ca"
    sha256 cellar: :any, arm64_sequoia:     "f4ca48178c374cc3582f1ad990b49ec325c6d1f393874970f96e8f9d4ed1de14"
    sha256 cellar: :any, arm64_linux:       "9c2ab525c8719fba5458c259f6d85e8f11998f8e386fac571cb8df76c75d170d"
    sha256 cellar: :any, x86_64_linux:      "8f5fd5d8976d7656e8b3487cbd2b1d06df45518daae4d473a5a0225f561ae08b"
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