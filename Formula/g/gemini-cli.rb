class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.25.1.tgz"
  sha256 "de80abe5101ca3842fbf743b69786ef0aedb699a88c9de3cd4a9d1ecab8a66c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c39485c290fb74bcf3413aa19eec592ad4d531b54c0ac64e50224b09b78b8204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c39485c290fb74bcf3413aa19eec592ad4d531b54c0ac64e50224b09b78b8204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c39485c290fb74bcf3413aa19eec592ad4d531b54c0ac64e50224b09b78b8204"
    sha256 cellar: :any_skip_relocation, sonoma:        "31d46f526575860261a21aa4c7319953873aee73c4dce97db3bbf7c16cfb3451"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dfe7b94fb27c9209717ee61461dff75f502d1a2d8cee87c892b9e8e91fbd6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e8767c721d841a3a29b808d5b1a752388f5c13e90b291ffc657a50ce4285802"
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