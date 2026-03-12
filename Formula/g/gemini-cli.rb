class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.33.0.tgz"
  sha256 "31c92a15243e7c74f3f06ea7018eb14d04ac626e7e213488f01c6e920f65d500"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "466b51433191812dbe97f352b15be0a0fc2e25c0196599834cf011c2f073a150"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "466b51433191812dbe97f352b15be0a0fc2e25c0196599834cf011c2f073a150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "466b51433191812dbe97f352b15be0a0fc2e25c0196599834cf011c2f073a150"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8ccf2d57482fd291b0d9e2b07f3e752f2a615ac3dae244f8d77282093b9e944"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e1fd11c58a3bb1a1a59fc106219e86f10c9ce7806339ba943c9c213d8a4a1b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36398005eb4ea64ce5199aee35dca3295de823ec6282772a5eb63f50c75b4e0"
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