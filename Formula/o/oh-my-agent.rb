class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-9.5.0.tgz"
  sha256 "e69fe7d1f034c44c76ec948240df51324ec2c05dc20901afe390b9da7a7f8d29"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "31bee4dd36fdc439013403f6d15883032ad845c3ff2fd6cc8a92b473fc2be8ba"
    sha256 cellar: :any, arm64_sequoia: "8b1c8228548d25266618d1c4e19b4a88939c87f86162b7b0abb43dcd6bf3a40c"
    sha256 cellar: :any, arm64_sonoma:  "8b1c8228548d25266618d1c4e19b4a88939c87f86162b7b0abb43dcd6bf3a40c"
    sha256 cellar: :any, sonoma:        "12d750b6339d266477eb6c7b6e55da7d8aa1b40ea0c5ac432ed0af4312281ad7"
    sha256 cellar: :any, arm64_linux:   "4ac642c5c81390b0ece03aca66191972f5a684edc1b8809531f544385871e3bf"
    sha256 cellar: :any, x86_64_linux:  "fef3ce517c46a7d28a1987987d84cc47d06e6870af364b046ddc28dc9979d42c"
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