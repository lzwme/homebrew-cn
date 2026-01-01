class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.22.5.tgz"
  sha256 "d727f1f08ff9441c67661a91a0be183e55a0e09a077bfaa58595167906df6861"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96002bd823f805450ff7e3bb61a97f36081836b11722310fcf31f8316841687a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96002bd823f805450ff7e3bb61a97f36081836b11722310fcf31f8316841687a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96002bd823f805450ff7e3bb61a97f36081836b11722310fcf31f8316841687a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a035a14fbac63ac2df3a2c077278e38c48ab7ff056ef5ecc2710455c5564d5d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "117e24e78b9be6040db52a55d08ead42f9345dcb4bec36bbdaec322f897e5359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af897dff3455e8f5ea7f00a56475af1237263ad2e643fd3563dea9cccefe9f28"
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