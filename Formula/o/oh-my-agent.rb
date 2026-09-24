class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.14.3.tgz"
  sha256 "7b0a5f7f1e8f3480b6487b38682733b9c8168c98b051c998c67ae9ddb793ea26"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "280d36e530f20e4bc8cba304706f99309ccd51eec018259843447a885119a856"
    sha256 cellar: :any, arm64_tahoe:       "6b7bf71fdb53882180d89bbee869234ea458525e1daf8afec0b0bc0e9bdf9d23"
    sha256 cellar: :any, arm64_sequoia:     "221db03426b06c9eaf76a4ea8c4c57f3a8cf49579f04640e20b9e6d60dc21dc1"
    sha256 cellar: :any, arm64_linux:       "c4f4458463cb7c0637efad4bd1a4bea5b7769517fc070520502189507d65b30d"
    sha256 cellar: :any, x86_64_linux:      "4a8421c29b9038eba5d6f1da936f52bc915d6eed7d770066bc65c5b3c732117b"
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