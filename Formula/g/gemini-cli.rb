class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.28.0.tgz"
  sha256 "64697ec1d0db1fc500dec29b563efeffeb762fe0a6a742109da45b144a3f61d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f2bd9ce7cfd4dfb05ae8b94ff7151f251277be8d35ec5f4c330418aab5d44b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f2bd9ce7cfd4dfb05ae8b94ff7151f251277be8d35ec5f4c330418aab5d44b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f2bd9ce7cfd4dfb05ae8b94ff7151f251277be8d35ec5f4c330418aab5d44b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8075a135a4c9198121a754d81480ad34d1ad8c136b979476192e4835a1eeef0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5add4599438351eae368ee5fbe458cc07f122b3919069bcafb9d909e67feb03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "170ea7f39e4411e5ca4bbb34694a9e0f51eacd2e4ed6639d57a09917e42e7294"
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
    (node_modules/"tree-sitter-bash/prebuilds").glob("*")
                                               .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    (node_modules/"node-pty/prebuilds").glob("*")
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