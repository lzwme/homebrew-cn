class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.22.2.tgz"
  sha256 "61a3cc7f660a8f6578a96968042223af64e79c506740338133ef424f75dab37a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7360ec2bd6ae177a1ae2ed1c2386b84afa13fbbff3ce354606e82c9d11958d25"
    sha256 cellar: :any, arm64_sequoia: "7360ec2bd6ae177a1ae2ed1c2386b84afa13fbbff3ce354606e82c9d11958d25"
    sha256 cellar: :any, arm64_sonoma:  "7360ec2bd6ae177a1ae2ed1c2386b84afa13fbbff3ce354606e82c9d11958d25"
    sha256 cellar: :any, arm64_linux:   "453f7c7fbfebd8397714239c0bed0aeed4fa041b3b091d1f55fc7f1f7cede819"
    sha256 cellar: :any, x86_64_linux:  "84d0018ebced0ccd71c2be78e91e3fc0ba701def1c1144cc550927b2e663d076"
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