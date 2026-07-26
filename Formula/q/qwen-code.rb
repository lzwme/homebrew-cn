class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.0.tgz"
  sha256 "62fa5ea404a8d1f694edc54446bbd4ca6d3a69e090ec5975977ff51918d2aeca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c976875cd3e6ce4586eab6d86f79c478c7b6b5b72feaa845a8ca977cb5554958"
    sha256 cellar: :any,                 arm64_sequoia: "c976875cd3e6ce4586eab6d86f79c478c7b6b5b72feaa845a8ca977cb5554958"
    sha256 cellar: :any,                 arm64_sonoma:  "c976875cd3e6ce4586eab6d86f79c478c7b6b5b72feaa845a8ca977cb5554958"
    sha256 cellar: :any,                 sonoma:        "b7c47285d28878ec77cdcf03b844317888c768ad5dafd7bda57cd7dd240b1761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72a9272606d8d3f9597d8c92d886dfac172798115508970952723a646283c42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5ae68f085459ae1ee38b33daaaccf4fd72924c22823988824442d3e1ea2cef3"
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