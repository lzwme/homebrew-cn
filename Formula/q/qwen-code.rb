class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.10.2.tgz"
  sha256 "b644c58bc659c5ad22ee30ad63ff2e2dd73eb9df9ebdb76426050a31c2e3c580"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76d1816c0a8a48ac0797fd67c7112f2b4ca48940fba3e3edda92aa3e0703641c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76d1816c0a8a48ac0797fd67c7112f2b4ca48940fba3e3edda92aa3e0703641c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76d1816c0a8a48ac0797fd67c7112f2b4ca48940fba3e3edda92aa3e0703641c"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a4aae5302f7fccb81a3b456e59c0c6a75eed844f7a2c4869ea6474d607c58c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70c5201af9bf82a350fe5be21968aa6943798e67b2f3ab05677ce5f7106a0142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "157a527089621d2218c6727e9b18b108959cc6969dd97f718fb3fa4f2f04ef35"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end