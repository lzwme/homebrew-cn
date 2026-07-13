class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.14.0.tgz"
  sha256 "37ae2ff95371e69a60a3e30f61c2ed9f03bc8be198de76e23c6feeccdea2452f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "76ae0e431755530030d4118d6e5343b257b617f68b091c6cfa24be1fbf29842c"
    sha256 cellar: :any, arm64_sequoia: "0938309ac7957da0a8c71f650b2df234ad7ee7cbd086cd8f130d029fa87ca233"
    sha256 cellar: :any, arm64_sonoma:  "0938309ac7957da0a8c71f650b2df234ad7ee7cbd086cd8f130d029fa87ca233"
    sha256 cellar: :any, sonoma:        "520ad2b1b4d6803f69a9407123051173fd35e5550cab67866b7edeae4dd1ab52"
    sha256 cellar: :any, arm64_linux:   "bc9273ba5ba1c2330ea8bd09d117401f7180090654b48e9dc0e847a581f28588"
    sha256 cellar: :any, x86_64_linux:  "47b9ed6ad28fb04207880be1f683b0f6542058bb323c6df4c6039800ba616726"
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
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end