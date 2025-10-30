class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.11.0.tgz"
  sha256 "c08a26486a0b8b766c0046047f5ea69236dd9bef9202bd528f31a6c1663967b9"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "d5b199074d8002d0a9a5a59c6d8c3ef9d8492d102efb0f6bdd915d7f63792cb1"
    sha256                               arm64_sequoia: "bae3a8e80ebb4f00e475f5c2b99c64a65999dbe8655c2415214b8709b7b713f5"
    sha256                               arm64_sonoma:  "db5e58cbecfb5c3da109ec8e348b794a4b7915d742bbbd2d294e296f78bcf61b"
    sha256                               sonoma:        "aab05cc8b5ea7811f51b07840ba2d0a5a4190f99138f3054d56e9c10bb88fcbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02f237da98c81b66813f197678b0a0a7fbbdaa73d5a346b5b07a3d1c13b0d800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "021eddd258375a873e37cb54dcbebacdbeea7f7e8ad16ab390fa7183507abdbe"
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