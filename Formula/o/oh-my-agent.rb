class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.10.2.tgz"
  sha256 "34b909a16dac16c406cbf6d12e11649d088b69f4d679e46bf63559278373c1cc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc1c5c6012f7b6a540d4aa899e800f8932385173652fddfe7166c4d84991f857"
    sha256 cellar: :any, arm64_sequoia: "2046b727a999e713c5cfa3d32f8695153e607d542573192999fbeec0fc360aa3"
    sha256 cellar: :any, arm64_sonoma:  "31fe20a4f38ac422585a9f036d5a9b8ceb7ff18043749ce86c8cdcd17f44a541"
    sha256 cellar: :any, sonoma:        "ea5c1b1bf2e8ada920abbb01a9604d1594ef3372fe8c3c281eee1aa1896233ff"
    sha256 cellar: :any, arm64_linux:   "0e24e86d3d91cf93d3019c37c6cca85fc043eef6a1f2e30f0bf7c69e2884fdc0"
    sha256 cellar: :any, x86_64_linux:  "be64afdce2a88bd6c5182201a7f1e2fa548b0e518477920fd350ec8c04a43bad"
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

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end