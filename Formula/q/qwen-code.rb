class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.10.tgz"
  sha256 "fbed92cb005b65a9b74fa140fd4d3bb0abd8505384c1c3c419600fbfe26cf4ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "985b45a39430cc8c5de8be322a3ff68336932e61d047b465a8a366247551ed5b"
    sha256 cellar: :any, arm64_sequoia: "985b45a39430cc8c5de8be322a3ff68336932e61d047b465a8a366247551ed5b"
    sha256 cellar: :any, arm64_sonoma:  "985b45a39430cc8c5de8be322a3ff68336932e61d047b465a8a366247551ed5b"
    sha256 cellar: :any, sonoma:        "270114056227a52c9abf6c45f35f53839289069e862fe1925cfaa4f0115a94be"
    sha256 cellar: :any, arm64_linux:   "3468254332137269b53b0e46449ad40837276dbb33287da0049abf43fe690834"
    sha256 cellar: :any, x86_64_linux:  "6be7ffbb3c2ccd01500ffa36c3eb522577350e71799222a3104fa3ba0f8fd9ad"
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