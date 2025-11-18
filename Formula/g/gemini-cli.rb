class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.15.4.tgz"
  sha256 "737038f92a93413f1c84d34f5a87ee9030cd4ca7bd9d7212ed23d79c54a81432"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "6f25fe8b3e4ce39173dac8d85ef2f1692dc3195d9723b8fe965d8c0b97102046"
    sha256                               arm64_sequoia: "3026989e950d1b517fa0d2c158d28b0ce627065def6f2a58aacce0fd47f75e35"
    sha256                               arm64_sonoma:  "74edb517570179e5a44524336a718a226bf974468ae1a81499cd1da4e3b77474"
    sha256                               sonoma:        "23a5647045396d6104b0f6b6aad4ad5d26e4883b5c784c8566bb88b0498fbcc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2803ffa1e02e108c7e855c0350b825562b4149cb10ef15acb19032c16ec1e308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1508470f87e15d2039c41fd090e0d7c3583a0227b704b90e6cfc94348c2a3e00"
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