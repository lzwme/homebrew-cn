class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.32.1.tgz"
  sha256 "0c747270f7bdf9281f88d640147b46d363c89db4e825483410d0f8c741c9463e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a2f2c393cc88d9b1172f72bc967e4c6c01cff9ec737f71f6c274e68d4d46591f"
    sha256 cellar: :any, arm64_sequoia: "6364371eb981664bd18a68f63f298e7903673a58a821cd627ea0e8d5c658241a"
    sha256 cellar: :any, arm64_sonoma:  "6364371eb981664bd18a68f63f298e7903673a58a821cd627ea0e8d5c658241a"
    sha256 cellar: :any, sonoma:        "2a9fa61cd919c3abef869808c1457cd9222f9f88036ccac85c9d07a9e6c0283f"
    sha256 cellar: :any, arm64_linux:   "9c9cf20e56863ba298865d4ccb89fb25ad61980190d860092dd5a416aed45ea1"
    sha256 cellar: :any, x86_64_linux:  "edd9f545f83581bc1a933ce425188db1f0c7413751dd244ea674329dfeee36a8"
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