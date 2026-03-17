class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.33.2.tgz"
  sha256 "4da4f451e79b5b7d8c70350906b7ff3b0e40433084547e93663376009942eda8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22d404b89c425af8094869a749f2d01a0c71ffbf6aaeb9040a87c59bf7de17e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22d404b89c425af8094869a749f2d01a0c71ffbf6aaeb9040a87c59bf7de17e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22d404b89c425af8094869a749f2d01a0c71ffbf6aaeb9040a87c59bf7de17e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e9785558da2549415bd37ab2d1dcde5977aec0799fefb6ac442b1e065d949eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc4394baeccf6f109e46011c5394e4fa95b581104e8972dd534e31db7acee6ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a56196c7dda2010f03cdcfe11cd97c020411bc5014cc8010d0c4735b9df32bdd"
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