class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.16.0.tgz"
  sha256 "a7f28a12a48a3e10a5edc910cae141bb08680e558f190d9e76a303aea1f12447"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "68c34e88e64fc99df367335dbaab07d1b96ca8e170e541b53b521028ab0733e0"
    sha256 cellar: :any, arm64_sequoia: "95b697e30ea504ee928de57bc79742ab8a9bc6c854d021875fc6963fa87eea24"
    sha256 cellar: :any, arm64_sonoma:  "95b697e30ea504ee928de57bc79742ab8a9bc6c854d021875fc6963fa87eea24"
    sha256 cellar: :any, sonoma:        "84f9404787f17eef5efa8b1ae112a32d2c9430ae02f9a9075ec632061b254c10"
    sha256 cellar: :any, arm64_linux:   "43e8277648631fa1840f4dc43ea4ccf050dd9120e4e6cdf3a08981d0f5b7808b"
    sha256 cellar: :any, x86_64_linux:  "4d8aeef03be5082f1dbc017c3e102f81b114cb9ef601daa807dee9b3a3ec619e"
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