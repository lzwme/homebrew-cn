class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.33.1.tgz"
  sha256 "b5e87ff217602679c97790981485cb234970643102d74503041744f64103caa5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3da11dac60cb6526f3776e3e25dcfde07f60c1e82f5652a0695bc6acdadf3f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3da11dac60cb6526f3776e3e25dcfde07f60c1e82f5652a0695bc6acdadf3f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3da11dac60cb6526f3776e3e25dcfde07f60c1e82f5652a0695bc6acdadf3f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e689dee8f988bd4c7532a908c38da67df8ed5e2b84310b250ce8b986f48a14a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00afc63ceb4472b1c0e76b817853f8b789824e908431dac8936c78fdfdb60cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1703f026025910fcb81d308f9043eccf8f22134ee1115e5e2e3f9ef0ce1bfa48"
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
    (node_modules/"tree-sitter-bash/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

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