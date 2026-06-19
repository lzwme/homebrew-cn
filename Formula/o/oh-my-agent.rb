class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-9.9.1.tgz"
  sha256 "882e19dec6ea2a054a04b02a31307f5acfd368f2d08d9df7911033ff7a514e5e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0514c6592e310ec63aa780f91655f9e69d43bdd96dc83320a9725e83a672af54"
    sha256 cellar: :any, arm64_sequoia: "76fafaec1f3afc889165663851c1a88356055b36bdfdaa471eb48b06b6742c06"
    sha256 cellar: :any, arm64_sonoma:  "76fafaec1f3afc889165663851c1a88356055b36bdfdaa471eb48b06b6742c06"
    sha256 cellar: :any, sonoma:        "4802d81ae1cca4336f484b33fd47fe1629d361202b993b23557b082e93f2257b"
    sha256 cellar: :any, arm64_linux:   "96aaf90da2ea96130ebc363f6c70db0f3322c1fffd789194c6fda6300e0185c6"
    sha256 cellar: :any, x86_64_linux:  "4e7913d031e7b39531164701a6d226f34dcd2b204f6bfe0b8332c7468f35487f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end