class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.27.2.tgz"
  sha256 "923b4d4086568a8cdab11ac402ad9624c822436e5a154726ce96d4a6ee44cc72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56a5340be972d575456c25f87699a6708ab40890301ddbe772e994e818b8e94e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56a5340be972d575456c25f87699a6708ab40890301ddbe772e994e818b8e94e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56a5340be972d575456c25f87699a6708ab40890301ddbe772e994e818b8e94e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6e28f126ded089b732f6988b4a672bc3fbdb93757a12a57f4a0e11c1cad3288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbe46e62b0c3fecdcf228c1edcb319a63edb34a39a8e9c606f5a36c5555279e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67d99b0489a841df1e25502865c7f7fc6d4678608eec12ea10721b31fe5a80a5"
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