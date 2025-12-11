class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.20.0.tgz"
  sha256 "4cc7875e42ce6d470c95e8b12107e27505a81b6698ac09f5518f5ab2ffff893f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e8bdecd117a6698247387f9ed358eb5c133a009c02c54f69d4cd7588aa49db8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e8bdecd117a6698247387f9ed358eb5c133a009c02c54f69d4cd7588aa49db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e8bdecd117a6698247387f9ed358eb5c133a009c02c54f69d4cd7588aa49db8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a896e2ba0f2261472bbacaeb52dc78dc0284f600867d2c32d328e6f6064cc5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f7552dfecab5ff5236c37a3cc2ba283a6f5fc2a1cdb286659ca066959a3f036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c77114ed6cb503cfe1b82283386e80558c18f62a11e670aff5b922ebec1d18fb"
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