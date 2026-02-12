class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.28.2.tgz"
  sha256 "5e5b2d221b39f5c0ffbda565afb61e029ce41fbcd4acc57aed0fb466d6fbd19e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ea01ff48dc70b87cd3fd4281f3cd8dc11d3ed0a6b2cb32c73223590dacdccf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ea01ff48dc70b87cd3fd4281f3cd8dc11d3ed0a6b2cb32c73223590dacdccf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ea01ff48dc70b87cd3fd4281f3cd8dc11d3ed0a6b2cb32c73223590dacdccf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "77c7117540b330eb7d99b62f12cc27c263528c4bf64ddeacc0bad2457dc8fa70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23169360cc7ca820624a0c3b0c785a9ff3e59a09307a12d28abe6549cc34e530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1998d04fce027c840001fd3e6f21284f46c21bb1f37000d4ad46b9f6013ff9c"
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