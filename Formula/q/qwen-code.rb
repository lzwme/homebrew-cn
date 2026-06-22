class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.18.4.tgz"
  sha256 "02a6eadeb4d082adb5a6c13378e4e7a12d2d0f6cbaddc568f475a5ef37898fc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2fc0a9fa58d83d8313373c8ea9cbec41c47b9a0972fd151be96f9c5ccdfe968e"
    sha256 cellar: :any,                 arm64_sequoia: "8e62ccf3d9502d16a3457f496f767a9b8fceedaa5f06a278b44ca17e0e91e1d1"
    sha256 cellar: :any,                 arm64_sonoma:  "8e62ccf3d9502d16a3457f496f767a9b8fceedaa5f06a278b44ca17e0e91e1d1"
    sha256 cellar: :any,                 sonoma:        "178495a1a324b0f19b853f3c5fb13c2a260308b9def238bbf819cf761804e788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b273bd9f3042a53886ba2a8238cc65f03a6ffbe1d0f3c4fb55832ddd0598550c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee64865842cc7d40d82bacae8da692507a6baca4984d0e0c88e32f01bbf9adeb"
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