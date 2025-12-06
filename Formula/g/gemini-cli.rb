class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.19.4.tgz"
  sha256 "2ae7ab76decd7133d2fd72993860e5860c4fcbe3b570855de73db11cb417b4b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6be559c5a052b9d9bb1f868b43cab71e82abed1d2269feb82ab6d5238fceeb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6be559c5a052b9d9bb1f868b43cab71e82abed1d2269feb82ab6d5238fceeb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6be559c5a052b9d9bb1f868b43cab71e82abed1d2269feb82ab6d5238fceeb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b2108b13c084d5fe9e31da2e16cc02d46e5770beba91abf2a333f51b1a9cd53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "307a36ac07998e36c4debff4f508a862a9cdc39dbef99fc59be4159585656b02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab90d72b3d96f9f0aa419a84938ee2f09b915704bbb6115a3a0c065fb94d9f30"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    libexec.glob("#{node_modules}/tree-sitter-bash/prebuilds/*")
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

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end