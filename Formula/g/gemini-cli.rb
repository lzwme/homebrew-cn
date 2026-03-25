class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.35.0.tgz"
  sha256 "7c9492f079d24da00075a69794da0c46387bfd7777491306a6fc415fff70755d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb2de3c08334bdc144aeda329377530602a026cca4098fbf240aa735567a1998"
    sha256 cellar: :any,                 arm64_sequoia: "beb69fef568a108a949b78661110add7f7d346ebac3977297ef1fc51555e3202"
    sha256 cellar: :any,                 arm64_sonoma:  "beb69fef568a108a949b78661110add7f7d346ebac3977297ef1fc51555e3202"
    sha256 cellar: :any,                 sonoma:        "e1add08f3300e60ed6e3d0ec2604cccb669f68f7ed511ec872a3fb84da1efe90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9106f93843968021ba1df61aa2fe0152e175b52720580863815d909e02ab322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b992e8c424e480b4be3199c3b92fb4fb501908ef9dff9a5cb5b1ada2eb1fd41"
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