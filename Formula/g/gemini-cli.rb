class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.24.4.tgz"
  sha256 "44ec58bb628952a72879399790257bf823dcc6c803d6e94f5df0aa3b949eae7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ecc26d1b397e075cafe2948718484aaa1126871558a42b157e5cb26037f175"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4ecc26d1b397e075cafe2948718484aaa1126871558a42b157e5cb26037f175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4ecc26d1b397e075cafe2948718484aaa1126871558a42b157e5cb26037f175"
    sha256 cellar: :any_skip_relocation, sonoma:        "8008c24c7ee1a58d9ccc98d16129b6a9fd6d612466e6c093238680c240ba833f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7fd320420d0c3f264a156ef85352f3beac6856e530bf9e3c15d608c7255f980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ce082bab392f8732c0b84283ef13f5e2cc09ba0293d3b5b72fbdeb29d9e518"
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