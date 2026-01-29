class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.26.0.tgz"
  sha256 "3bb6e356cfa64c42ed0fef25af63b11464d8ffb2aacd438b9b89182301d49200"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1980775cab656f7a54e8a45cfbf74c08ed0cd3a11852273af13229c1527dca33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1980775cab656f7a54e8a45cfbf74c08ed0cd3a11852273af13229c1527dca33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1980775cab656f7a54e8a45cfbf74c08ed0cd3a11852273af13229c1527dca33"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0b274c3db8d35dc397deccf7c89e9890e65ab447a48b3d541e901087c7440e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "198f958e91662e35e5dd7c88bf9eb63de213a24f656c4f6c94473b9fb0c953a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb73502527e6471968693444d154e0e629295a604dae7442e31cc5faec0aa8c1"
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