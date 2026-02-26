class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.30.0.tgz"
  sha256 "87b09a01c362266bace55bb69095da573579c5a2f16cdf9fff42c0abc230a15d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f62e19ce165bd03af2b53f3072af808241aa86ee4e6b89b1d968a85770d8342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f62e19ce165bd03af2b53f3072af808241aa86ee4e6b89b1d968a85770d8342"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f62e19ce165bd03af2b53f3072af808241aa86ee4e6b89b1d968a85770d8342"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c74ee2a00347f5dd59efce4778e43bed5c1c39659582e172765ee3e63ee757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "011f9063dcfe83343b6ac94629687d21e18889e78de81d73575e55431d318734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb686a914ee1654a4952bdc18833a9cc62d9d1dda5f4b090a9e894e4b4a1bb7f"
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