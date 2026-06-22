class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.3.2.tgz"
  sha256 "dcf067993cc2306740d18aa95acd4f095984feea15e931c4f7f6c36294b9803b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e9ebfd30be7927049f44fbc4ab40817f2940af0a238ebb1c4c96e8f9e8bd777b"
    sha256 cellar: :any, arm64_sequoia: "a1fa512899eeb12972d8c7e4d7feb97983b0a7f66e7b7dc97b02f64965fbbd6f"
    sha256 cellar: :any, arm64_sonoma:  "a1fa512899eeb12972d8c7e4d7feb97983b0a7f66e7b7dc97b02f64965fbbd6f"
    sha256 cellar: :any, sonoma:        "77720ba7d91fd2a764282663182d45729e455f3667535cf9d2fc55f48494857b"
    sha256 cellar: :any, arm64_linux:   "3147f79f29537384be712b1a2756865c79e785169ddafe06656b730faaf1f8d4"
    sha256 cellar: :any, x86_64_linux:  "b205c4c9261e3d009d68d9dbc838df74069a3ef41eeabd8176a89964b40480ec"
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