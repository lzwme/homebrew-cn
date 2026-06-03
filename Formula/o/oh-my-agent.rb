class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.26.1.tgz"
  sha256 "889ebb23d4d0aa7fe3e00c365b21525694367762264bb3ede3204dbe22070327"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "56d27656736b12ef1512fc98d02eb265f85de8bf20561754f1ad728008e7a701"
    sha256 cellar: :any, arm64_sequoia: "1468a1a7200720643849bc1987d1416619ba042e46e94d8a60147fd8a60ec2a5"
    sha256 cellar: :any, arm64_sonoma:  "1468a1a7200720643849bc1987d1416619ba042e46e94d8a60147fd8a60ec2a5"
    sha256 cellar: :any, sonoma:        "48d5976e7b8c97251aceb6f7c24a8f9bcd79d89e9d3307c5e9f8fdfbfb58fbcd"
    sha256 cellar: :any, arm64_linux:   "8514b2ed5a098f31c2bb3d3dc05af121b827d8a0ab4a3ac38071673499808bf7"
    sha256 cellar: :any, x86_64_linux:  "4a5618ad04e9e9a30191853d3d8f308ceb3483d24bbf9fd4c44e65126b6753e3"
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