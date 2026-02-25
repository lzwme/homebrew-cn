class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.29.7.tgz"
  sha256 "8cadaf20c72deaa5d16d540cc187fac4c32741e129986626984335a5b71ca228"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90b5974c0f1fbea9f4f4dcc24214c8c544f8c476f658d78f3aa672b0e0290f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90b5974c0f1fbea9f4f4dcc24214c8c544f8c476f658d78f3aa672b0e0290f3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90b5974c0f1fbea9f4f4dcc24214c8c544f8c476f658d78f3aa672b0e0290f3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "17e1460440420533f4c82d38d63f1a678d18bcfe0251c59fa2502583c1296612"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad737a0b0cbd18a0ea3b5dbcb954932ed7308a59c2973e33a10163f70a15869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a0aedf248ba637dd12267d9146a04570c208c262082b883778cabf0b906957"
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