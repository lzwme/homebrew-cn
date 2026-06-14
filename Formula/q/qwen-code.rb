class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.18.0.tgz"
  sha256 "1a245573348a6ba2d014bce421b2419d9d2e7affcb76889f1fb97714772f1fd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e5c73147ab3fddff54696d8ac6e46da1cb5c641085ed611538425b4b1c8aa338"
    sha256 cellar: :any,                 arm64_sequoia: "45bf40adfbd0d38b529a8d0ce6c1c88e910794777b69c881f26e51b22eebc2b1"
    sha256 cellar: :any,                 arm64_sonoma:  "45bf40adfbd0d38b529a8d0ce6c1c88e910794777b69c881f26e51b22eebc2b1"
    sha256 cellar: :any,                 sonoma:        "4e3c6a0d8538c2e24f27955ec32df8ed6ed565335c0cbc3bb8861df78971905c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4016068e5b762f7e48db51624adf7f71a5e562dd1cd013100dee7123640c2a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed5d007dfe9ecd6d739f65b733ab1fcfee33a4ea5aa3eccf8e15b789eb68785e"
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