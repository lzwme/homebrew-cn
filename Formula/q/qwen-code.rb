class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.18.1.tgz"
  sha256 "e9688d330896ae60fcc70b516fc8af0ea557bf062d298a72664f6e46c8161ac8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1741d0a477aec2f08582708272a3566b95a4c93482793b0f11d0ac2179ff574b"
    sha256 cellar: :any,                 arm64_sequoia: "abfdb335763f26fee40d11eff4d9bd0fae3c89acc69478c454473ca1520f43fb"
    sha256 cellar: :any,                 arm64_sonoma:  "abfdb335763f26fee40d11eff4d9bd0fae3c89acc69478c454473ca1520f43fb"
    sha256 cellar: :any,                 sonoma:        "85ea399704d61bd70310210dc86d19e8cecd3fcbdce58a883b59cdf68cd45eb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65aaafa2c151f0ee0ac21f6bca637cfdbb680da9c1957b5b56a37eca9bd2e59c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ad0543400539d553edfb53bf6d8d66d0150c5f479ae53ab5d8fab2b37861ee"
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