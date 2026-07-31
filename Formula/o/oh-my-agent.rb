class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.2.3.tgz"
  sha256 "7e62a59b1060ebddaf25b64a8cd700c60337874a4da632212fcbe103305c3f01"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "def9d45381af7938d9e950412f2bded760a5404cbc039467f4629023cc81fc53"
    sha256 cellar: :any, arm64_sequoia: "def9d45381af7938d9e950412f2bded760a5404cbc039467f4629023cc81fc53"
    sha256 cellar: :any, arm64_sonoma:  "def9d45381af7938d9e950412f2bded760a5404cbc039467f4629023cc81fc53"
    sha256 cellar: :any, sonoma:        "94c34b5c9de4998e83951d726da9bbf0e19417f08d435cbfd921cb07aded4b82"
    sha256 cellar: :any, arm64_linux:   "0fff08f21f4c32608f65e14353ff9e14dede7a271a00b8c4d7f715562fbcabc8"
    sha256 cellar: :any, x86_64_linux:  "056d87bc75c947b6621dbf156c2652a2bf63dc42709662f2e85e9655d8905caf"
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