class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.20.2.tgz"
  sha256 "4d9da964f0380907d8c839ea8bd80589e5015d308ae802b7a05818f017d29ccb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e30efa4ab7355624c1b97e761d6bf32a631edbdf2158dfbe78d370ce9d657026"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e30efa4ab7355624c1b97e761d6bf32a631edbdf2158dfbe78d370ce9d657026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e30efa4ab7355624c1b97e761d6bf32a631edbdf2158dfbe78d370ce9d657026"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4d912c40cd5f3fbda0bf24ef6b3ff7080b5fc1221f761e5ec1b2717bd33009d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cefe7ac3f45ab135d4d132e5af09f5304cc48798cf39a17eca78f104b714ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23445e6ffd643c3009f4dcfc1eda1431d14af12766c447e78e829a66bdfd3da1"
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