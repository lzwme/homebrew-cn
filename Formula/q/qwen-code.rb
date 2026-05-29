class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.16.2.tgz"
  sha256 "ff3285eed2f0df52ec1e5e39d79ceea03fb6e775b1533a5607bf98c226b47e73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc455d8a479d439cdbc91cc8e9d1d150767458c13ee5e4e1a307894230f67e52"
    sha256 cellar: :any,                 arm64_sequoia: "b21f28ef75f9f05b4668eb7b50619103a3e1474213c5204088cb80222dcf1dee"
    sha256 cellar: :any,                 arm64_sonoma:  "b21f28ef75f9f05b4668eb7b50619103a3e1474213c5204088cb80222dcf1dee"
    sha256 cellar: :any,                 sonoma:        "6b29c8be3f0edb57134ab66589a07f917b6a522baa5159db0bad19b802f4f45d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e46e065fac58ba0e1934966243a7235ed3f41b75d8ba41602e20a9ca2e51e0d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368ae034600862d531426984145d1bf2622225add9c7f3e791c10c4cc8858405"
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