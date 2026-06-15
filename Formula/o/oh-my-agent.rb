class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-9.3.1.tgz"
  sha256 "740854b55ba340b04ea0d39383edaa9d07057edcaa5f999221d0adb6f94a808c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de6efe37a8028b1df30d96ed78f677d3d9f3a6801a5da8fbfec3fa9235d43030"
    sha256 cellar: :any, arm64_sequoia: "69a53ec2aca41f0d3ec94ac286e98b292cdea1a8fc3760250ec54934c5a652d2"
    sha256 cellar: :any, arm64_sonoma:  "69a53ec2aca41f0d3ec94ac286e98b292cdea1a8fc3760250ec54934c5a652d2"
    sha256 cellar: :any, sonoma:        "41095d54db44832e2ed4e7fb6643e4bdd80bf4621994ca8bd60be79116f162d7"
    sha256 cellar: :any, arm64_linux:   "6529b50cffa67032afb140da442bf9d6b3dbd8503b62473bfd1247ac4aaf22ca"
    sha256 cellar: :any, x86_64_linux:  "8252396e28b0279b5b2babca802fbfb560ad3d7d9c56bfb3891adbe751bc0e39"
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