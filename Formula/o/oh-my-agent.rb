class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.22.0.tgz"
  sha256 "ca869cac905a20d97eb4051266c94f2281ba4d0a4f810e5e167da45d8be15fbe"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6f26c18be44b2b3f8d5d789bee970450b62f61cf3a2cae4a777ab5eec2329fd"
    sha256 cellar: :any, arm64_sequoia: "f6f26c18be44b2b3f8d5d789bee970450b62f61cf3a2cae4a777ab5eec2329fd"
    sha256 cellar: :any, arm64_sonoma:  "f6f26c18be44b2b3f8d5d789bee970450b62f61cf3a2cae4a777ab5eec2329fd"
    sha256 cellar: :any, sonoma:        "962bb23d67d5a1e6e96674c0a4b4dc8aef9ddfda850bd7f3e01981c07eee8fdf"
    sha256 cellar: :any, arm64_linux:   "2d3aca8385302de4bd66a1689aab72c24b5a6858769abffe16b159265eb2a482"
    sha256 cellar: :any, x86_64_linux:  "4383291272e618c338ed2762d146d502867376ab775c2d753404c927c5421fcd"
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