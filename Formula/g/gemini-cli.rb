class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.35.1.tgz"
  sha256 "30fde80127c6af4a08c81b7107968cd0675bba2861c6972d980bb2194a767386"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3cc74a3f734541daf538aa1b4cfab89ad93840ccdf76d4acf20a0d12d0d1e68"
    sha256 cellar: :any,                 arm64_sequoia: "4a2f591ea4bdff7ce2979864f65cf435153c74dc3e1995b1d7dcc0931474ddfa"
    sha256 cellar: :any,                 arm64_sonoma:  "4a2f591ea4bdff7ce2979864f65cf435153c74dc3e1995b1d7dcc0931474ddfa"
    sha256 cellar: :any,                 sonoma:        "94a3595e4ebc640f523e982fbc498256ef885e529148392bb9182efe36b8fb60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9beb9d533f4135f4ae1febbfa1c92781d10a012cea9d61ac059f0696ba1d85a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c82eb2f79138f07977ee3fc91fdb702cc7ad397d86bec679760f7faa7b42605"
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