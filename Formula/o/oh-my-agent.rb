class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.7.3.tgz"
  sha256 "a5bdb7efdec6ebae907c3c240091e2d247c3558ab87d0c1424c9bb8e025519de"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "90bb7cd9a860495dd1a74dcc07f18a5e1115d72a1b4188c45f96b93a1cc9fbf6"
    sha256 cellar: :any, arm64_tahoe:       "1a6fe71a644ca8b2c9a815074a135a2a2969d8205f24877be784da940b724d9f"
    sha256 cellar: :any, arm64_sequoia:     "1affe2a102501c0c799f48b0ac9928e9350751b398926f8006ac705eee3bca69"
    sha256 cellar: :any, arm64_linux:       "e47bb9a62544b8f60a97d32fc2bde32a1cb2d127c708feaa73aedd20fe5eefb8"
    sha256 cellar: :any, x86_64_linux:      "d52d7198f6e2f5cfee52b02d5da53ede365c2810302c4f498941d0d1eeb096ee"
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