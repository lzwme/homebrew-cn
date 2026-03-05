class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.32.1.tgz"
  sha256 "5ac01b1abc59171a675698d6902e6674fae5a8a771342b5b2e039aed54b0a241"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9ad9e903ece1dc4ec3c6e0cc7418a45c897a1fc3304c17a8dd4b167142c3ec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9ad9e903ece1dc4ec3c6e0cc7418a45c897a1fc3304c17a8dd4b167142c3ec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9ad9e903ece1dc4ec3c6e0cc7418a45c897a1fc3304c17a8dd4b167142c3ec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "788ed62fd8c284e411fe6f84f517c0a8bbf325f4ac8822bb9169330ab17672b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9009d0c786d1ca7839c23138f5daf90ae85b9b829007f15a03bd16a17ff7b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f942e94cae9d2e6d89380124f3ad2b0902d2c8a623ca1f7c239653e7669c86fe"
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