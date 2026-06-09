class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.44.0.tgz"
  sha256 "2b63b82c214f6a4d5765bd0fdc797d04daa7cb705319a486f8c8ad01b589c9a5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "db81b05cd77107a078286d0410fa54374fe6efb06df98ddbab3b264cdd9cd3d5"
    sha256 cellar: :any, arm64_sequoia: "0b7b1164cb06d591bf331b82b1fb44c8f82232bf11cb774e462091224ddfc76d"
    sha256 cellar: :any, arm64_sonoma:  "0b7b1164cb06d591bf331b82b1fb44c8f82232bf11cb774e462091224ddfc76d"
    sha256 cellar: :any, sonoma:        "5f91864852c4e09bbd7fe6adcc21e98070bd896090e75ea72c224877f9c6c470"
    sha256 cellar: :any, arm64_linux:   "4724343723b60b0300047586b7e268b1ad4f89a4140431dbbb680ab846ce63cd"
    sha256 cellar: :any, x86_64_linux:  "7f33717b6e513d477313b6cc4247dea047ec36b07552baff62875712932da54e"
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