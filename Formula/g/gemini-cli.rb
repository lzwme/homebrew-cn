class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.29.1.tgz"
  sha256 "6ea743a2c414c4b3ac17975698a88bd07a7de6b21d760d8d653f5c2a0926dcb5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eef20b6e449ea6cfc68f9f8ec9c7d3b900e747c4234749c7b9e02fb2ebfc2bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eef20b6e449ea6cfc68f9f8ec9c7d3b900e747c4234749c7b9e02fb2ebfc2bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eef20b6e449ea6cfc68f9f8ec9c7d3b900e747c4234749c7b9e02fb2ebfc2bdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b55087bb2d6e6c924c9c3072e0163bbe473ba9bddb8a22d82e314deaf9f3d763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0dac43265b5a60c6fd844e8f06c002f1e2381c23ebc96d463b9d7e5be8fa316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "567f46ad73d02849f970209a4c249942ba890d111eb0750d7e9e883bc466df62"
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