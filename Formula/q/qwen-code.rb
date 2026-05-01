class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.5.tgz"
  sha256 "455473f00c40a6678c98ca617dd5fd7c9f63c9fbca55f0589da50123d51183fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf4edc90eab6b542c6008fb1470a32ebd8687ccf75b49d76bf6f0d669b131667"
    sha256 cellar: :any,                 arm64_sequoia: "a53898efd1d4f0eade8372e09db4e4880ce68b31756211d1799ced5e3b6155a2"
    sha256 cellar: :any,                 arm64_sonoma:  "a53898efd1d4f0eade8372e09db4e4880ce68b31756211d1799ced5e3b6155a2"
    sha256 cellar: :any,                 sonoma:        "7a635c2d629a180961f6253d40d650026b6635a467422718f352552669152643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df8d73984586638bf2725baa8f3a2b7ac5d1a329abdf372652afcd29251008d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8764450f184be710ab1650fb8391a847adb74965b0f027117ba958adb787b242"
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