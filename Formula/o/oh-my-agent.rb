class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.12.0.tgz"
  sha256 "ab6af5a3955fc046fa215e277d69a17e1bda9f0e0d4e554d7269aef9af5d2fab"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "29f663b5a464bc71598a499578f94b7d5aa4ec830a52cf577269c2abecd1fc01"
    sha256 cellar: :any, arm64_tahoe:       "dbdc1c1cc2cbd3b79942c4372f09482405294635d2db7176b00cb335a8634c96"
    sha256 cellar: :any, arm64_sequoia:     "75b7f43d660c937a1ccec7b6bfe1818318adeef3369af1cb24293be0a6c9de43"
    sha256 cellar: :any, arm64_linux:       "3f3c4c8499c5e5647a9e1d8e9586dba90341711b7f76b66b4ebcf4ffcb4c3801"
    sha256 cellar: :any, x86_64_linux:      "ee9afdf913c6a42ec61db6a547d4efc84bb9ece238a59be17ff25eb0b1d0318f"
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