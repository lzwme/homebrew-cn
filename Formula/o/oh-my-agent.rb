class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-19.0.2.tgz"
  sha256 "e61eddb07db15f3b231fd96de438bae4cc867e034f1ba0b35df6c95ffc130403"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "29ee83a8d3f83deb61d335087720ba7eb1060884db521f5e5ad8cea74fd7d684"
    sha256 cellar: :any, arm64_tahoe:       "246a244369f0dd88ad8b755430bf294b652b90d73161444e528f105ecdcef8a6"
    sha256 cellar: :any, arm64_sequoia:     "7876985bd38e514bbae983d2de132882f06492e8f427191dad5c91ab7bd013ab"
    sha256 cellar: :any, arm64_linux:       "6914eb0d7dea2e982c6b6ddb00e303504a6ab9393751497db7a509bc5a562e8c"
    sha256 cellar: :any, x86_64_linux:      "2146e2156f265f66c27a2d479b17f91a914c71f33c2e0116e2ab1619c54ac54e"
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