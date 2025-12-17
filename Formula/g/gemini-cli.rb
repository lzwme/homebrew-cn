class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.21.0.tgz"
  sha256 "fa39ac9f5c2d289a671dba2476dd7ca49a35ca5edc961218779ea34fe40f637c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fdc71b21e26aa3475145f7df180625702ce3cb27558f4071e2c547d2e9c6a74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fdc71b21e26aa3475145f7df180625702ce3cb27558f4071e2c547d2e9c6a74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fdc71b21e26aa3475145f7df180625702ce3cb27558f4071e2c547d2e9c6a74"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef603f026bd6b351e688f5766b1ac412410055f5cc8a1ba899af7827bb0c61e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc0745725f4b5606d01e226bbeba8b01f455ced70cb82086f72d3d759d67368c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0bee5ee84a7eedd8472009a44976daa811c544f705183f8b5cf51f1d380a07a"
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