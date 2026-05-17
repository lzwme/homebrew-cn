class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.14.0.tgz"
  sha256 "821cf58a550127850ec0ab85c9594ad31efe58bf08583fb95d9bbddf8a08cd83"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b5a0ccb3f7211d593a33dda5f856aec3b142aee1a0a5290db6968956b31e8d3"
    sha256 cellar: :any,                 arm64_sequoia: "425e7708a750a8682e216aaa1b54b53a8fa4f5dfa9cd61ed01c3b9e4ef3cbe84"
    sha256 cellar: :any,                 arm64_sonoma:  "425e7708a750a8682e216aaa1b54b53a8fa4f5dfa9cd61ed01c3b9e4ef3cbe84"
    sha256 cellar: :any,                 sonoma:        "fa2ca5cbd9a17ac7247d20b86978aa38ff9dd34a2a9daf5da3f70853c50cd9bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0aadd65fa72f9418c5299e3be47072617397c099d45b661dbd3062424ddd763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e804c94323c06c5d9d844ca5416d82f6ebee87f096f91f3cdd39aba78f92f533"
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