class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.17.0.tgz"
  sha256 "6d2abece09ff466a354f9d40b3d4b914a84bba70729631954603757ee0acc167"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "2411c0759c0da433dc1fbb98f7182b4ec0fdc91d231e51c6b1146f17970a95ef"
    sha256                               arm64_sequoia: "57ed254300441a04876413d8cbe37468dcb680fa597984072b19911a99c4510f"
    sha256                               arm64_sonoma:  "28996955a1e4caee6239fec592ca7f557463707a985bf7595925d2186ea5a0f4"
    sha256                               sonoma:        "27ebc307fc1279c3c36b98f0db38c0f6947036eb85497194e73262364375dbd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a72a0e48c3eb042487ded219b2804db2d119664e4b1d8b485a1bae3e73be2fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47b62c52c1a5ca86c7e93d8159f894c9f69cd6cf085bdaee046bb24c285db5bb"
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