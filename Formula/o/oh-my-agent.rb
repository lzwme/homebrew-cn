class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.5.0.tgz"
  sha256 "d70f3d89e0fa6733f98b737ca08439278def21cdb06ce1a866b4e1b4b38367f8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "44d4dd3626bceca9d90ab0d71aed8b9fb8be8af5ac92dd56fc96af5fcb800fc4"
    sha256 cellar: :any, arm64_tahoe:       "dd2e616363b813db6ebd3b386953452fdc5c061380a3103b19383ad8f6ff775f"
    sha256 cellar: :any, arm64_sequoia:     "f4aa6d7c9c7e71d570c0a2e453e790fe17500647a333b4d11a833437508c8370"
    sha256 cellar: :any, arm64_linux:       "5107f1fcf8a5b87ad179d92dd64666cbbe7c9c1e0c4a837b4ea915d8222a4c5f"
    sha256 cellar: :any, x86_64_linux:      "3871a88d7617c7054f32dfdb1853812a7f8d29678a195483e1afe93701648c70"
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