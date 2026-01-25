class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.25.2.tgz"
  sha256 "5717c1b2930f6b35ed25e781cf96b83e83bc5350172e66dc226209a672bad512"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f14be8b3db7368911d807b58c82efc01565b136f31d86598b6a1fa4d71cbe7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f14be8b3db7368911d807b58c82efc01565b136f31d86598b6a1fa4d71cbe7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f14be8b3db7368911d807b58c82efc01565b136f31d86598b6a1fa4d71cbe7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3275ea235cf9fac6488242e4307c74d50f7ef097b357d89eaf6f84dbb124e2f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8276205e29b88f0cd680a6a6ead6d1893fd8c8e250ecac8668f3b11d143851f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fd68d378006b255bd18faa48f1903b46c4a785f0ccc807e00e7192b0535b944"
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