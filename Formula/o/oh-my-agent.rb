class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.7.10.tgz"
  sha256 "5f948f96611a46f5efbf57ab8dcf1044ea21ccaf06032e4a94b47b1e9e8fbec1"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "398c8807dd9ab4e59ef7a27d65d0bd293722f767bd6b19eef22018ecc25c635b"
    sha256 cellar: :any, arm64_tahoe:       "ae7b0de0167d763d18d41106f2104a9a740f435566a520772c470ebf48642fe2"
    sha256 cellar: :any, arm64_sequoia:     "3582ca9e90d4d436c39bae0c545dc875a7c3a6c218c95cae8ab2de71c3a4f1fb"
    sha256 cellar: :any, arm64_linux:       "e6aed4c431705ea047805482fab715b002d8b7daddb803964361bf3b08fbdbd6"
    sha256 cellar: :any, x86_64_linux:      "fe811f2ea857023b04f5ffbe206b1f49781a47060cfc835e42e42ae8df9a2559"
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