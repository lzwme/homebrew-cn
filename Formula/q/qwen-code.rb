class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.26.3.tgz"
  sha256 "55194c90e1c376fbdf682247a787e12e58d159a0a11c27f162ec9b2f48cee0dd"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "50ae53bb9b69d8bbaed2c57e0c7dffaca37cad4ac0d7e67fde6f6536474b5202"
    sha256               arm64_tahoe:       "50ae53bb9b69d8bbaed2c57e0c7dffaca37cad4ac0d7e67fde6f6536474b5202"
    sha256               arm64_sequoia:     "50ae53bb9b69d8bbaed2c57e0c7dffaca37cad4ac0d7e67fde6f6536474b5202"
    sha256 cellar: :any, arm64_linux:       "3493c652c4afaadb9ed2180143faf58a4bea80f342cc78aac6f8a8ad6c225df9"
    sha256 cellar: :any, x86_64_linux:      "19d11aa0260aca0a6928e94ff5ad91063ad478d0b6fa77b077733ce401ce9159"
  end

  depends_on "node"
  depends_on "ripgrep"

  # OpenTUI loads its native library by path, so keep its relocatable install name.
  preserve_rpath

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    qwen_code.glob("opentui-assets/@opentui/core-*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "core-#{os}-#{arch}"
    end

    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

    qwen_code.glob("vendor/landlock-run/*-linux").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}"
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