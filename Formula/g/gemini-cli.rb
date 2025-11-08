class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.13.0.tgz"
  sha256 "06652bc2d911229228c39002cd380568f9f7274d31bcca3115bcafd9579cacb4"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "a53ccde613e38d1331cfb63a08d574fa7554629d72ea4825d5ce445b15942143"
    sha256                               arm64_sequoia: "79580985c9e9898622eadfdd278bf404a0f6ab27361a44d92399061b413460f6"
    sha256                               arm64_sonoma:  "6110f707d05b0def8f646fbc9753c2c469dc789ad0dcdd92ae6a3c324168ca90"
    sha256                               sonoma:        "e5e41cc3f54941776b7ce37834666a41e259a5ef460f2c07be235bc60ea7d344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc6a104faab7f82fe9f1d3c0bf7d27a5870d52e9ccc9b84ba2c3c598f32b78b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39b932e0b70608961b703b5322fdae488e0534cdf4baaf55bf0acfbd95cabdd5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    libexec.glob("#{node_modules}/tree-sitter-bash/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end