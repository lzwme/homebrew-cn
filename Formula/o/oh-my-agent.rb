class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.12.0.tgz"
  sha256 "27c4e78ae14866eb5748ce133f4823a9696fa975a95a502eba7219b92f7d73b9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "485052c8d130d7a5acdf13c25aa89a8177eeb0c857b3120e54cfdc1512d1ed12"
    sha256 cellar: :any,                 arm64_sequoia: "5e6dfb3b98aa8a064c25b46cfc6fc89ee8ca60e6f739c93fc30dbfc7c138647d"
    sha256 cellar: :any,                 arm64_sonoma:  "5e6dfb3b98aa8a064c25b46cfc6fc89ee8ca60e6f739c93fc30dbfc7c138647d"
    sha256 cellar: :any,                 sonoma:        "621660fdca0e507724cec7e9013753a829f4a83244f91c5eea94d3716fbaf459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53221b87421d1721b73fb91fbd3b80624a6ccf74e7cc9628d06c2517ee4da77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b80714f4b7ca79f3caa04177ea3762c83d38ee4bf57f63d97d4d9f41c92a354b"
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