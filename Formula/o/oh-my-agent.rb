class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.8.0.tgz"
  sha256 "a977ae54a1bbfbc379d9dfca157e1399103ebae7160619ca7ff38e1ac0e29cbf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c0e6897f5f2b83dcf2c7456ca20527cbe4745e1c4a9c2140fa1b4296904da1b1"
    sha256 cellar: :any, arm64_sequoia: "bb64aa359985be0007b5d49c02093079565049d1199ab8d9deb3df2a4401dfa0"
    sha256 cellar: :any, arm64_sonoma:  "2589de4fcaf95a116f87d6d61a7156f4c53ea6b9f4b1480ce7c58c4c22d73e1a"
    sha256 cellar: :any, arm64_linux:   "451434c38b12679f7a7bce8bf3f4e087a268c605b6831bfe9bcb1bc01c72819b"
    sha256 cellar: :any, x86_64_linux:  "12e73949c0c92d359ea348639fff145399165dfb46fffe44ae6deb064f5a2275"
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

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

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