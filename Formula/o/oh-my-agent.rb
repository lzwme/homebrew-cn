class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.30.0.tgz"
  sha256 "64787fc94e9b97fda75f5c96ea5c58bf7e18dba3195f6ac17bd426bc2b501142"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c7dc88c6306474e00e995a9c46fa50ebb6e37fbcb66a9740b2c131b987f7428b"
    sha256 cellar: :any, arm64_sequoia: "de2e3d04030b76695186313d2a78af7e57193e9decf8b7c679ef5a82432987cf"
    sha256 cellar: :any, arm64_sonoma:  "de2e3d04030b76695186313d2a78af7e57193e9decf8b7c679ef5a82432987cf"
    sha256 cellar: :any, sonoma:        "fb4dccbc1a65553d806941cce8caef86024e1b7f8309f639c289868e9ebfb8ae"
    sha256 cellar: :any, arm64_linux:   "3ffdc8110c3fa7effdad918c0a7dda2156cf3e28a618ea6902978b730c0546c0"
    sha256 cellar: :any, x86_64_linux:  "16cb351e6622832aa2032f80ea2ad2132f29643e200ce011d91bb488dd8f14d9"
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