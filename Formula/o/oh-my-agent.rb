class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.9.0.tgz"
  sha256 "7999626ae510cf7537fde1d309d029fbb4f3be499118241c4432ce9908fc18d2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e0092a994ddd63cb71065c3e8c54b1ff5cc3f48490cbdda1ce731e59e1371669"
    sha256 cellar: :any, arm64_tahoe:       "07fcbd9c780fa58da0cee30872bbd7e4304b8da1ed4955b14e77d4746b35fbbb"
    sha256 cellar: :any, arm64_sequoia:     "dd633f2ca5aa23d87b0c79ee33eed5eea3c120b205b14612ebd9ae321e517651"
    sha256 cellar: :any, arm64_linux:       "4c0f1ac5130efa553a49b485d7a05ca5539c73dfadc397320d994d62ae763d8f"
    sha256 cellar: :any, x86_64_linux:      "797947c512437747a8403d36551c339987c7a2d0efaec77b10042bcf225ed721"
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