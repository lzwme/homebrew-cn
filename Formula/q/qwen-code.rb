class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.13.tgz"
  sha256 "b0bfd51d89c21ddbe214c568a7afb93ebc14b1dcf79967ac84bffdc01cb1ec53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b37ff436c429309f64de6f076c34dd2b91f4ed3b6c8ba2c8e1425c3fbd9f9bab"
    sha256 cellar: :any, arm64_sequoia: "b37ff436c429309f64de6f076c34dd2b91f4ed3b6c8ba2c8e1425c3fbd9f9bab"
    sha256 cellar: :any, arm64_sonoma:  "b37ff436c429309f64de6f076c34dd2b91f4ed3b6c8ba2c8e1425c3fbd9f9bab"
    sha256 cellar: :any, sonoma:        "e79d33cfa7541488db09c8d6d9a53bab0b0428565a0346cd0ec8887c702a66a9"
    sha256 cellar: :any, arm64_linux:   "542741f1c4d0b38f8b8dc4751557250fa87ba7a6f8d6ea34fa2082bcf3583b1a"
    sha256 cellar: :any, x86_64_linux:  "c18d46f6f14a71cc42690382ae849edfe1dedf4334b4e73560a489df2eb9df2c"
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