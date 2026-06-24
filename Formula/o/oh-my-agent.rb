class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.4.0.tgz"
  sha256 "4cb1a6c4a003c57c6c15f9588ce06936a63a9478cfb8c5358089b31cb96c6fd5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c8db7ceed6724080e386f3dc111928864ceaee1c4529de75d07bb9fcd05d1c53"
    sha256 cellar: :any, arm64_sequoia: "b0958ac5080152a17a0c4af634ed49ad0b7abafd96b0ea018cd99bf52754a624"
    sha256 cellar: :any, arm64_sonoma:  "b0958ac5080152a17a0c4af634ed49ad0b7abafd96b0ea018cd99bf52754a624"
    sha256 cellar: :any, sonoma:        "c26a51cfb7d55d495da25f06989c8b6ce1962b3ac2da0ed07d214278bb4416c2"
    sha256 cellar: :any, arm64_linux:   "80bac8fec065611f59431ef65e461ec083cd4606a8d795b799da0023fcfca470"
    sha256 cellar: :any, x86_64_linux:  "8c41c3d11b7f532ecc772aea5c37570a962857bb8da302165e79e4cfb297c64c"
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