class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.35.2.tgz"
  sha256 "b4235b3253f5187f8f838aa007222c46c94e703245d18f3e0e5b6fdaa8ec7905"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "afa7fb0e52d85ccab2e50e7d55ab8657b5aa2d8555d868d34155b7221a05270d"
    sha256 cellar: :any,                 arm64_sequoia: "1d52e03f5ed8f0490383e92506fa0e6559d10a821962537f07ea03d1810c2e64"
    sha256 cellar: :any,                 arm64_sonoma:  "1d52e03f5ed8f0490383e92506fa0e6559d10a821962537f07ea03d1810c2e64"
    sha256 cellar: :any,                 sonoma:        "305c8e0064f92ab3773a881ea38872be85318a497914541b4c8d5d14b6a1f4f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ed33f3c46807ccec71e63c06c20e7668559c3a0fab8c5f049c856f7a3acacb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab0acdb4f9ea2335efbdda931a17fd0b40b1637949a13e691d821016466db75f"
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
    node_modules.glob("{bare-fs,bare-os,bare-url,tree-sitter-bash,node-pty}/prebuilds/*").each do |dir|
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