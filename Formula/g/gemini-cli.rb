class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.21.1.tgz"
  sha256 "9bbe5bb69e4231d25d82eb48a128a76ad55252364cdd9b98b503139edac800fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "beeb9cf42798238ea1463223f0c83d389294702e297c0be14d7d30238a952709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beeb9cf42798238ea1463223f0c83d389294702e297c0be14d7d30238a952709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beeb9cf42798238ea1463223f0c83d389294702e297c0be14d7d30238a952709"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f48bacb920f61db08407f1877b17de3795095b201d49700d6d63258d65fd168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "890221547833acee9088888c0f26690d76dc3e5ac80d63780326cf959ddf5825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae008d3de41ae15366247234380f089856c112a8a31f863109ff07e625300358"
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

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end