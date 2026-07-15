class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.17.2.tgz"
  sha256 "72214003ecaecf852e474bf9d9799e6919392dd17cc7e4285f98461e07318ada"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "20cbaa08b970cfb46918738b077679e4c2c51718e135fabec32a4822659c8689"
    sha256 cellar: :any, arm64_sequoia: "20cbaa08b970cfb46918738b077679e4c2c51718e135fabec32a4822659c8689"
    sha256 cellar: :any, arm64_sonoma:  "20cbaa08b970cfb46918738b077679e4c2c51718e135fabec32a4822659c8689"
    sha256 cellar: :any, sonoma:        "492d3d0b33ba64b5e0b4b72f1a9cbbe0b2a8062394502102d10e3409731a32f2"
    sha256 cellar: :any, arm64_linux:   "47e2dc2ee80ef3ecb4eb804bb174872cfe51dbce59faf72e30c464917a8c51d0"
    sha256 cellar: :any, x86_64_linux:  "3d0ce07fa3a8df26d9048e9e73e59cc1d64e16627ea3ed05b16fd0c3de2bd6a0"
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