class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.22.4.tgz"
  sha256 "06a2980802fedcaa1d71699fe7c96717a725eebc8742bc4fa63225b035089520"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87a117edc16009b7dfdb6fef3ed1ab8e21c58c39d854b29e1b21689d21d17fa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87a117edc16009b7dfdb6fef3ed1ab8e21c58c39d854b29e1b21689d21d17fa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87a117edc16009b7dfdb6fef3ed1ab8e21c58c39d854b29e1b21689d21d17fa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3749e489302c2fa06ce403e52bab33acc48c34cb3821b537dcc83c737db87a41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b73454c95fcab9a05d1b133f9943e6732a3e9943cd06d74f12d48a30f14543e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4dc6dfd8cf3f415b7b51a591daa20035fde1ac9869ae92dbfe15f191ce21cb4"
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