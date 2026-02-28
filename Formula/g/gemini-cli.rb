class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.31.0.tgz"
  sha256 "9a8fc0377c6c55ab28ed9fcffc2092cff9a40778365ac9c2d63d882125f60344"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e28015e15ffbdc97e49ff153079d4992051277e64de5e07ecbcc2be14e2de56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e28015e15ffbdc97e49ff153079d4992051277e64de5e07ecbcc2be14e2de56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e28015e15ffbdc97e49ff153079d4992051277e64de5e07ecbcc2be14e2de56"
    sha256 cellar: :any_skip_relocation, sonoma:        "b199f0eb11221dc2b007fe9a8eda1e75358f5e2a7d04a9fc314816cf053890cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aff7b451a3bb45e93aecea8afccc913d049a79f4825a9af383f66e2d4cfb4521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b361b512f49c0ee46692c12df74a99a3b2dd11ca410bcc0fed40c22fc1149bf5"
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