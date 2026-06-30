class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.7.2.tgz"
  sha256 "71526a1aad615f64ecc3bc2fdbaaddda3f4cff99b7fa4f74c63044944ce42160"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3737a91ccfae5271d1d888c709f20568b83cac0d7c8ab45ba137a81683f7e552"
    sha256 cellar: :any, arm64_sequoia: "2ab0e887715198f751deac9e8a79b601a3ae5c1d6141683b9d064c9308585289"
    sha256 cellar: :any, arm64_sonoma:  "2ab0e887715198f751deac9e8a79b601a3ae5c1d6141683b9d064c9308585289"
    sha256 cellar: :any, sonoma:        "52650f2ccb715fdd4a791619dcda3d5f187930ec03d26e93b7c5ce5e3b029f46"
    sha256 cellar: :any, arm64_linux:   "e8be39c841f2589b7ddaa72bfd0d040216826dbd5263ff79dcf3ba9dd2b777a8"
    sha256 cellar: :any, x86_64_linux:  "8eb5483480d2132e98b6c6dfc9213903d42b94edd07e8507971e4a10ac192609"
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