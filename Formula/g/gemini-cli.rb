class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.27.3.tgz"
  sha256 "f6fa917da1a215adb09480f13006dbedcb2ebe8d0e05c3db5bbb1f1bceda1509"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94d917cd78842c83e3c865aca3416b034594cc755b69b4c2f8483ca2f4469f04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94d917cd78842c83e3c865aca3416b034594cc755b69b4c2f8483ca2f4469f04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94d917cd78842c83e3c865aca3416b034594cc755b69b4c2f8483ca2f4469f04"
    sha256 cellar: :any_skip_relocation, sonoma:        "e78d4d0cbc240f1eb4d3a16c18a8b96bcfb71ca4ee3437578eef7cec3e7c9132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b7bcdbf5cd2b03b935f345d3ecdda4a806b699808e18e5c16349a3216a15562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c878f461c77f4ba2800a85c96675e3e9bc4ef6d716cb81065ba672a3071ab0db"
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