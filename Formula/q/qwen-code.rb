class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.10.3.tgz"
  sha256 "0b8989432f962b88659bd892db48a0a9e0b1b37840539ac53a271018d98d1fd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87ffcc4249dae085ce14575da18e808bdd77b9fe195a8c59274c15b07413b840"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87ffcc4249dae085ce14575da18e808bdd77b9fe195a8c59274c15b07413b840"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ffcc4249dae085ce14575da18e808bdd77b9fe195a8c59274c15b07413b840"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ab36c4c71bcf8e9a4e4d00ae4c2954db74f30fc9fa2bd6ed800203c1c25619d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1841d834127933b2f9508dba054e02b2340919f783cecb1d6f536b7f35ea0a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b02cb1ac4830a7e2201d21e1f4e7c314864420c943b62c8ad79a8f21725e4f58"
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