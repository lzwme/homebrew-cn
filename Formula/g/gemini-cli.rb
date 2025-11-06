class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.12.0.tgz"
  sha256 "8eef4daf5bda399ac60fbd163a7e4a1a585fc226f675465e93d63efa1aba08cc"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "84ea1b0568293f10391c96bf47712f02eef244f1595afb666bbbe36570b6674a"
    sha256                               arm64_sequoia: "46a015abdcdac4de0315def2655ece567cc9c2fffb71e07c06afaf60f34faeb9"
    sha256                               arm64_sonoma:  "e53000790facd7f68cfaa08f7d20f1f3a2ca4c78b717f1ce2f0a89315eabea5d"
    sha256                               sonoma:        "b2208532b06192716e61ca13a99e21c3d469c0cee510c080a4bad0531597c2fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1794d675cffa4be6f02588e0e03f2285dd1e3e136d43273be32abeb2c837363e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f267f51dcac651cab47980393cdd587bced5ae1036f1c7996d7e02fb7cab884f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    libexec.glob("#{node_modules}/tree-sitter-bash/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end