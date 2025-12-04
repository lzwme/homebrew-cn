class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.19.1.tgz"
  sha256 "360f3d182b7aa43994c7712f4480add683644239cdbcdba0054ec987ed789778"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1b2d167e0d6cf7207820c06e0643fb23c4c6066b11f18482c1b1029703076e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1b2d167e0d6cf7207820c06e0643fb23c4c6066b11f18482c1b1029703076e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1b2d167e0d6cf7207820c06e0643fb23c4c6066b11f18482c1b1029703076e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7d9062b5352b9e595b84898aed48bad7e2eeb7b6cf394892853880fc5aa6b19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3dfdef036cb1f36009e0c5f1b329d6ada279bad5d5da7f2a409d2fbce230cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daa01e1fd5de76b0aef320a27d237ebe2df160342d8c581412886dc8bb9208b7"
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

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end