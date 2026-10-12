class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-18.0.2.tgz"
  sha256 "27a9e787357c4e27f060b6e6a9b37f28dd26c0ff0ee82063bf77f99e6f6b3573"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "72114ec7c752a056fd0c8ee5d380ce63d9f6b2d21f55410589169ad17f8d1d12"
    sha256 cellar: :any, arm64_tahoe:       "cbf7ee202fd56f0c02b7b17c3aca4dbb07f1631abe27dc92a2192787c3180679"
    sha256 cellar: :any, arm64_sequoia:     "41fa7b696283e7385542a0170868a1baa8c187ba85471be59f723a8af80a023c"
    sha256 cellar: :any, arm64_linux:       "010e100c7b38b6762302243cb8cc5ec81673e24ff28d98755718c7602d383cfa"
    sha256 cellar: :any, x86_64_linux:      "1c3c3d9f3bff9af8e48b9e964e7873206810ccfee94e9f9a317e0c7aee8b5924"
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