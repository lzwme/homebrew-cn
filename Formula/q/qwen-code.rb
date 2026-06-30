class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.3.tgz"
  sha256 "4a9b0b40af73d88ee40973e569981601cea3b33e0ee5e9d2e2f9e3877b08114b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f642ca27fab4ffd5d53214f7ba8a2b10956b6a3ba928a274ee8e3dd62b44d15"
    sha256 cellar: :any,                 arm64_sequoia: "23c0a3554ff467a4c5f228c486a89653b9c3aeeabef2a607ee67f508cd159f34"
    sha256 cellar: :any,                 arm64_sonoma:  "23c0a3554ff467a4c5f228c486a89653b9c3aeeabef2a607ee67f508cd159f34"
    sha256 cellar: :any,                 sonoma:        "e5eae92422f8355591b02c9f58b83763bec0da2a47f22ab75bf62c9ab3fa02a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9418b0d231390ccfd006830ff1ae4dc796914992e618460cd5d64fe8a384f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f78edb0588e466fa9a0c8ca732e959c60c4f412f2ade7c98c67c3e28bb03251f"
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