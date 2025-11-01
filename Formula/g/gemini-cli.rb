class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.11.3.tgz"
  sha256 "277710db32268d5de9801ea6745f1b697d07006f4d160415b2d6444437d83d1d"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "fa166d2b0a2424207159f227726b88f5913e024ccc47301912a40355e4e75d42"
    sha256                               arm64_sequoia: "d354ee4413e88969aed9b5ab50cd4ec0f14af44dfbb30695f8bd24deef40be30"
    sha256                               arm64_sonoma:  "afdaf19025c4af4554eed3eb87da34feb566e8fddd881b305b69dd476919de12"
    sha256                               sonoma:        "36174939ae98d3608543fbad0965dac1396871f43345296107140948034acd4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97192cd87cc0b5dc0827b47376f020192b0a47cd037eab89e09a5fc3e76d3eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8374cc8378db8c5cb315918e939608cd692ebcb71716d539ec8d86c6338bd49c"
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