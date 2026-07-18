class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.19.0.tgz"
  sha256 "ec1096b150f2f4b7564e0aa7940a4d0eb9d88fab91a65d202f4fba36d175d5b9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "83704d41e66bf4374a9b15aec379a37dd98481b7c10c5ae6c341a89fb113a816"
    sha256 cellar: :any, arm64_sequoia: "83704d41e66bf4374a9b15aec379a37dd98481b7c10c5ae6c341a89fb113a816"
    sha256 cellar: :any, arm64_sonoma:  "83704d41e66bf4374a9b15aec379a37dd98481b7c10c5ae6c341a89fb113a816"
    sha256 cellar: :any, sonoma:        "a3b4c259bbee618494d8ed9b78c11e866633ece977d35587e56810c61242ef10"
    sha256 cellar: :any, arm64_linux:   "7a88f039ff5a9092572d82538914989d4500ba5191a9bd32655d43516e1fa091"
    sha256 cellar: :any, x86_64_linux:  "1924377b9c6ec2bc8b926011abbc75f0a8056a0d2e53035dfc31b58dda5dfa52"
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