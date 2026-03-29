class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.35.3.tgz"
  sha256 "e6316c4e76f3f4981c56b1193d44c371d6dbf910af9e400840a6bcbf464cce3c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a239d7f397f1dc5b0915271289b7f9da495e4497de148d00f8b5b012a1377010"
    sha256 cellar: :any,                 arm64_sequoia: "cec388f9e6dd655ef157aa330b5339ae5c0951f7c1dbbca5a32be9e07a0859e3"
    sha256 cellar: :any,                 arm64_sonoma:  "cec388f9e6dd655ef157aa330b5339ae5c0951f7c1dbbca5a32be9e07a0859e3"
    sha256 cellar: :any,                 sonoma:        "74b927e43046aa62970b32ae9aaba8e820feb733f13203dfb193c5cca8aaf442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "205e6667458d55d82e917f0f3c92ecdfa4a55cb3a3a6ae0d5ba35cdc15a47e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179b0c9dfa223e5f31c27616a95125ff26f041d631adafece2ff83a5efa5cb58"
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