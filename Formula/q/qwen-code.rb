class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.26.1.tgz"
  sha256 "9198d276e8583b789ee42a9c38b521d57818b94682d155b2b47741534c90fb73"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "ac8550902bb3c5f5fda368321f19704edcdece3c595bdb269cc523c1d53ee112"
    sha256               arm64_tahoe:       "ac8550902bb3c5f5fda368321f19704edcdece3c595bdb269cc523c1d53ee112"
    sha256               arm64_sequoia:     "ac8550902bb3c5f5fda368321f19704edcdece3c595bdb269cc523c1d53ee112"
    sha256 cellar: :any, arm64_linux:       "14cd770846a8d5af87945154f575c9c3cf27eb3fed30748bbc0eac0585764d04"
    sha256 cellar: :any, x86_64_linux:      "763cbb718bee020c665e731683ea6fcd345c407799f04309797aa8c925e59c30"
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