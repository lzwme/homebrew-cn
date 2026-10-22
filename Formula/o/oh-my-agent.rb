class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.10.3.tgz"
  sha256 "3d17e7db06fbffb3f4ef1ff24f882f284a746f15579f9d498f5886215bc4a563"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "22bf7eda6eebf9779502da504694127dd538fae35a7cdea531320ba958c636db"
    sha256 cellar: :any, arm64_tahoe:       "ce94a406d558d3b6c26501a91bfe993eb04999c9d1a7a5f622b7371308710d20"
    sha256 cellar: :any, arm64_sequoia:     "bc1771621e424a37a5e498f0345f8d649dde7fbf57171e9ab132bd7c86c5053a"
    sha256 cellar: :any, arm64_linux:       "778c94f8e0476e13bb8f7f885e758394610ebaf75cc19809bf2eeceb06cefafb"
    sha256 cellar: :any, x86_64_linux:      "79054da40878e7c35f036fe935709e75f17ba2f9300efc34b31f5ac3f8e3a82b"
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