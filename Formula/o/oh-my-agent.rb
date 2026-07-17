class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.18.0.tgz"
  sha256 "b05895f69d14387b14770729435ed10e6613246b1e503ce400ca1747f0e8c761"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "69a137f2c1b1a4bbbaf729de55500aed4d023e6fc14882a00697653b89746cc5"
    sha256 cellar: :any, arm64_sequoia: "69a137f2c1b1a4bbbaf729de55500aed4d023e6fc14882a00697653b89746cc5"
    sha256 cellar: :any, arm64_sonoma:  "69a137f2c1b1a4bbbaf729de55500aed4d023e6fc14882a00697653b89746cc5"
    sha256 cellar: :any, sonoma:        "36260425a1886f70e1a4197a375cf00337095fead01ee4a8849648929f4398f1"
    sha256 cellar: :any, arm64_linux:   "f7219a7cc44f0bfc2c3d437dce3250944950842a66d5237282676e74679ab3a4"
    sha256 cellar: :any, x86_64_linux:  "2890df4730712c1970abe8a8c03796a4ba7b8d5a5e6838ebd08c1d1133d29502"
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