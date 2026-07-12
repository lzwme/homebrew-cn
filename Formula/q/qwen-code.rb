class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.9.tgz"
  sha256 "a0b953668b5e5774c4e4ebe626f45a5bd78b6a8fc9c6fbac1f18533f019ed24f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78032645c5393e180840a71c572c26044a9d355e3f7b343479c4b45a5fdd7dca"
    sha256 cellar: :any,                 arm64_sequoia: "7b35fdf04f13ae57588c83fdf8d5776a299fd09970b6b224a849166ae7b89993"
    sha256 cellar: :any,                 arm64_sonoma:  "7b35fdf04f13ae57588c83fdf8d5776a299fd09970b6b224a849166ae7b89993"
    sha256 cellar: :any,                 sonoma:        "77de5b53cdd8a97940c7bb52651ef56dbabd449506e74349674e0267d15207c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "849c3dcd4fd07d973c0afecb3123c99a3f0014df200896cd1ea256a62ffee0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910ec20cadff33af44952198646ce8f22054df3383308feffb7a046601ead651"
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