class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.5.tgz"
  sha256 "7e4cb518e449cb49704e499d45e4429477276bee436c0852b31c8f5a799d5793"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be796cf4f45839a4c5c3a3bc867fb13bdd8c2910a7aad54dcaa3098abbea733a"
    sha256 cellar: :any,                 arm64_sequoia: "63954bf6f08ba16ab47214b4c114eef5e54eea048662f57725001853808b22ec"
    sha256 cellar: :any,                 arm64_sonoma:  "63954bf6f08ba16ab47214b4c114eef5e54eea048662f57725001853808b22ec"
    sha256 cellar: :any,                 sonoma:        "cfb44184f13bf4042047e524aa42f048cc7009fb08d8471ca3740224c0cb7fbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bcc583e9fc44e42de093c9e13c6fa0e6c9c0e53be0109e3ca7209d035f8b46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d178c175bddafe29662fe104e5281f863efa750eb31b3b0c8235bcced65695d1"
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

    qwen_code.glob("node_modules/@qwen-code/audio-capture/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end