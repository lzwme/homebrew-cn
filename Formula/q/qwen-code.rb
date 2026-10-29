class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.26.2.tgz"
  sha256 "01020fa2c701a1eb385c2f5405686bf25c5aa0b8e5cd8893e075cf0ad4d77e8f"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "a2cddeea259b79ff226290f2c590a4bfe4816733fb70882068f2b589dc4d227f"
    sha256               arm64_tahoe:       "a2cddeea259b79ff226290f2c590a4bfe4816733fb70882068f2b589dc4d227f"
    sha256               arm64_sequoia:     "a2cddeea259b79ff226290f2c590a4bfe4816733fb70882068f2b589dc4d227f"
    sha256 cellar: :any, arm64_linux:       "c8108cc2d0e8c83a81e8859f1bac2dbaaed82f40843f26392a17ab1bb893c58f"
    sha256 cellar: :any, x86_64_linux:      "f8aed5a1748174091a0889e8eedd1a37f9975cd3a873fa85a710e7a238b29e2d"
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