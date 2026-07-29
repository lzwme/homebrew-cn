class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.1.1.tgz"
  sha256 "90ca0ee184d31f12b4865881f18b716f7d3f27b54f4e871e9ba1e72288b39984"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e450e4e8b9a25227ecf8cda50f06ac19ffba6ff99aad10d330a2ea5d9ca27039"
    sha256 cellar: :any, arm64_sequoia: "e450e4e8b9a25227ecf8cda50f06ac19ffba6ff99aad10d330a2ea5d9ca27039"
    sha256 cellar: :any, arm64_sonoma:  "e450e4e8b9a25227ecf8cda50f06ac19ffba6ff99aad10d330a2ea5d9ca27039"
    sha256 cellar: :any, sonoma:        "4ecd138b2866d66f5ede8c9b5e21236121ce07972de9924aa6e3d38de1ac8657"
    sha256 cellar: :any, arm64_linux:   "58e43ed56c886167ce60dd1dc7163e3c88b1fbac87b69261f65d6a1fdb719dda"
    sha256 cellar: :any, x86_64_linux:  "7274c577f5fa480c6034945e3c10f8a3b37602c758564752975fb43a9dd8d67a"
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