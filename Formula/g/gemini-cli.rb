class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.23.0.tgz"
  sha256 "38b320c4f55745d98de8ab56d35c56ee627e88193c571bbb48062d50dada31e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88ac8a069e4294d84106be3fa8c3dfa1bff49dd13d0603ecbbcb7acda175509a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88ac8a069e4294d84106be3fa8c3dfa1bff49dd13d0603ecbbcb7acda175509a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88ac8a069e4294d84106be3fa8c3dfa1bff49dd13d0603ecbbcb7acda175509a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f86dca2ce25400f89db464fb4f8c9b4832596880d2457ff224ea8ae3e62f5db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1087c8c8f45982585dbaefb4c7d13ed4ed4c1cf87195769d1d084b503e56908f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b1375dcc39ccee608463ac34160f8f961451c7b6daa8ab767137caa3e473a81"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    (node_modules/"tree-sitter-bash/prebuilds").glob("*")
                                               .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    (node_modules/"node-pty/prebuilds").glob("*")
                                       .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/@google/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end