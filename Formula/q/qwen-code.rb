class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.16.0.tgz"
  sha256 "733c85be2607f009c6ccb9b64cfcb531ef46073c9eabfbd5974c75f4e14caf40"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fdc8d577992a29e586734f8d17ae38eb0ca1f775744c7f98f4f02fac6fb7f156"
    sha256 cellar: :any,                 arm64_sequoia: "3f752bd96d6f691f25dc20c1d9b148526c88e28dcea5eb0f8b8961863de030c3"
    sha256 cellar: :any,                 arm64_sonoma:  "3f752bd96d6f691f25dc20c1d9b148526c88e28dcea5eb0f8b8961863de030c3"
    sha256 cellar: :any,                 sonoma:        "e91a771cb6e8d8e7ac51916f260e49afc7960362dc88fc4cf6f7ba94b883d526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39140f6367430015c8b60d12fc3b8aab386338eb61f4c159ce274dd3a7e398c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c627cbaf1ee59bd425520f3a6994f4ee3930e31c71d556c92d513a0590b1347b"
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