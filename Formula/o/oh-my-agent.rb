class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.25.1.tgz"
  sha256 "e1cca28e8c81cda2266dde5e7bc2922839540143bb782d08ed708f41c0551f18"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "23570097bde4b4b3a2f4b83e1522bdeef08146ec2b6aa0659012aef068d3e9d6"
    sha256 cellar: :any, arm64_sequoia: "23570097bde4b4b3a2f4b83e1522bdeef08146ec2b6aa0659012aef068d3e9d6"
    sha256 cellar: :any, arm64_sonoma:  "23570097bde4b4b3a2f4b83e1522bdeef08146ec2b6aa0659012aef068d3e9d6"
    sha256 cellar: :any, sonoma:        "7ee8b5379c5503cde34d0b4e3afe3738e9d914c0a8b5ba9507ee71841842588d"
    sha256 cellar: :any, arm64_linux:   "5dd2191abe0d94ed88447499e9ed014e126fd8b8ccf52af1c31224b1094991ee"
    sha256 cellar: :any, x86_64_linux:  "ee8dc57b81abd67eb40ffe3f92f33e66c2662e89e10a803ce91406b92d31af21"
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