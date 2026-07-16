class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.17.3.tgz"
  sha256 "203c1d0cb99eb57840daff9293ded88dde7de01d6abf50ebf7edec969856c07c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3113ae358b86fe755cee7c8c79a115fd1cf54691cbe972b37af2d8304f13e447"
    sha256 cellar: :any, arm64_sequoia: "3113ae358b86fe755cee7c8c79a115fd1cf54691cbe972b37af2d8304f13e447"
    sha256 cellar: :any, arm64_sonoma:  "3113ae358b86fe755cee7c8c79a115fd1cf54691cbe972b37af2d8304f13e447"
    sha256 cellar: :any, sonoma:        "8f8d7a5e41c14a813fb73ce53033241beaa1eecb3594dfd41548a48c1f68fb09"
    sha256 cellar: :any, arm64_linux:   "6a11b59ee0b7be997b5bd6028209e6414a3ab71b6353c7b7e82c88e313644805"
    sha256 cellar: :any, x86_64_linux:  "27f670e48f1a4fd027083a5703ba91b0d99150410745b6a34601fdcca4f5a6c5"
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