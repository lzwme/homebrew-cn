class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.8.1.tgz"
  sha256 "8095d3229087ed376b77299ca2d55a786de414c60afd71758f06eb0ff69f1658"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "767f67d6a21a2b3955ce9c982b2ca050c12f58d57c06e5af6f9e9209e8f6210b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "767f67d6a21a2b3955ce9c982b2ca050c12f58d57c06e5af6f9e9209e8f6210b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "767f67d6a21a2b3955ce9c982b2ca050c12f58d57c06e5af6f9e9209e8f6210b"
    sha256 cellar: :any_skip_relocation, sonoma:        "68d20e7ece1ea1d89af885a491992aa79d728ab601f2edb128d1dd1e9b2bdc4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "424a11478e2ba666b77bf1b65412749e06aeb65f9f2c640e4558a200ef69740d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41f6639a77906c8dd2e8027f24aedb26bc9891aac3215a65eb391181f91ac8c1"
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