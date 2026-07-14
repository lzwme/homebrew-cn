class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.17.1.tgz"
  sha256 "929fd456cd5c9bc989a9a185a62e07a16d8a89381c3ff1734d0b05027d3040e4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0266543f5ef3c9f0853a6d19bb6f0c09b8e763f5759615f77b3dc7522bcd7fb9"
    sha256 cellar: :any, arm64_sequoia: "e10a31d423547d13808bb1c1caad8e11ba6ea147000da907a2c88dcf7f3f8e00"
    sha256 cellar: :any, arm64_sonoma:  "e10a31d423547d13808bb1c1caad8e11ba6ea147000da907a2c88dcf7f3f8e00"
    sha256 cellar: :any, sonoma:        "37ea5cc692259497098eac303ac5798e644f3546f85144cfd4c21f13877c237e"
    sha256 cellar: :any, arm64_linux:   "5b71c14765f22b3744e20ef86a024d65d45693f5dad0d678fef575cb3b7b8d2b"
    sha256 cellar: :any, x86_64_linux:  "d04138bfe6d28922725ee32e8fb4682cd0d48704dcdb0c232512f1ef8a81f2bd"
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