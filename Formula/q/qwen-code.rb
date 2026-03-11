class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.12.0.tgz"
  sha256 "229409183e73b7fe701e7520cbd12bcf8e12dc92c8eca0ce04319c9b08f3a52e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e5bca74120c66beebcf46afe02cbc3ff2ce58699277491cc184457a6fc37432c"
    sha256 cellar: :any,                 arm64_sequoia: "46297fd039e270dd00dec34ed856452d3dda1f24bba8e9e786f938cad444865b"
    sha256 cellar: :any,                 arm64_sonoma:  "46297fd039e270dd00dec34ed856452d3dda1f24bba8e9e786f938cad444865b"
    sha256 cellar: :any,                 sonoma:        "913cba07fb5d6132bc8ad6dc716724b6a6f49b4abdd9f5a8d4194c6dafd2fd47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "babd35c3534c55641d4cbb1c5a3123110d813f1c6bfb5a923620da50bba3ebbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08f64c3d235251eb145079a2d4c4d5ef150d8706f6ce0c6e600a56ab4708ef77"
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