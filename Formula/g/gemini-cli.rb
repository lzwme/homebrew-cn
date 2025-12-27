class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.22.3.tgz"
  sha256 "6362575039ecf9dfb1b472c85bcb9196e7e4bb8cb7d641061f343b4e37673ac8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84abf938ada5f7ac3f2db68c3934533d727ef4e769d1e486853765c65499cace"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84abf938ada5f7ac3f2db68c3934533d727ef4e769d1e486853765c65499cace"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84abf938ada5f7ac3f2db68c3934533d727ef4e769d1e486853765c65499cace"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a85271e6457f16645d02851687c8f44a93cef0e48fe324c68bc7a2145221a37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b19d5a93d06218c5f3f081c3a0ba86e3822ef19a8f03af98c5ecaad0b1b11b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a570208fb8c6b0214e2bfba99ed4e2e04d1c09448ec7cf1ed6f0947cd158ab5"
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