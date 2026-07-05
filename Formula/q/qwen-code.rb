class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.6.tgz"
  sha256 "fd04f660b7552841eb08dba567df4ca76ca9c269cca40cf78f96798d3751403c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a784bd67d3b230bf47418c7f0c7144ded6b7e674828e4d43dd50a3fbf7f18df3"
    sha256 cellar: :any,                 arm64_sequoia: "25a7964b52cfa562af5b89fc91fa0863db34025eff06086edbe82fc66b0fec71"
    sha256 cellar: :any,                 arm64_sonoma:  "25a7964b52cfa562af5b89fc91fa0863db34025eff06086edbe82fc66b0fec71"
    sha256 cellar: :any,                 sonoma:        "5db8eca7a0de06e326d148f1c972a60b6ae45291e2efed875719dbce7cb0d0cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12662448af77b37348db14139129206633e7c4b5a04e6b53e11bf33db88a253f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6201c6ddf6a4040e87ad66d7d6dab86b12712f595acfb26951a2980884965b15"
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