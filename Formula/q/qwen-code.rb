class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.5.tgz"
  sha256 "71322da9c078feb98051b92f2e212326cd9746eaf6a2b6e2e71bc36119a5004a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "350caaee7452544a477e1c24f714cb6b0ee0fa36fea0a59693a1aa165a37f315"
    sha256 cellar: :any, arm64_sequoia: "350caaee7452544a477e1c24f714cb6b0ee0fa36fea0a59693a1aa165a37f315"
    sha256 cellar: :any, arm64_sonoma:  "350caaee7452544a477e1c24f714cb6b0ee0fa36fea0a59693a1aa165a37f315"
    sha256 cellar: :any, sonoma:        "f41c9a3b4fbe8f0687ad95b0eb31051bf99e54a35499a2384c59ec1e5a08588c"
    sha256 cellar: :any, arm64_linux:   "d400ee07ea7fc9166f3fef33e9971412f525e5db614dcf37181e85fcc53279d3"
    sha256 cellar: :any, x86_64_linux:  "991dd1bc018e82529f1d811bc0a404504641bfb602eb99f809974631533420f5"
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