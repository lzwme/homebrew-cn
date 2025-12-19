class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.21.2.tgz"
  sha256 "ab882a44f7e66945db728a49e73f9ede3f4868c19cf6f89d601c2a0e559067bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8c6fc002ae375c0c19613c4e700305f68ed55d40a61faab19e856484704955b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8c6fc002ae375c0c19613c4e700305f68ed55d40a61faab19e856484704955b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c6fc002ae375c0c19613c4e700305f68ed55d40a61faab19e856484704955b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d6539ab341cc18fb66230870847e603cadc75018e60b76944fb240fc776fa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09eb25556d9a6e43be1eb1cc043346d336ac130108f8a14b3d910ed89275a780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3322aeebe8b0aea4a84bb1bf4b93c0e99bf5b654cf21c9c4d263f93669c381f"
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