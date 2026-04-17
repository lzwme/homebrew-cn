class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.38.1.tgz"
  sha256 "797c8f8a04be450c33097e69fa9e1584154a81deef2702ccbb0013fe93dfa458"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51286ee28c593254f6650dcf426910bab12e3cbd3693f201b554a2fa01b7d673"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51286ee28c593254f6650dcf426910bab12e3cbd3693f201b554a2fa01b7d673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51286ee28c593254f6650dcf426910bab12e3cbd3693f201b554a2fa01b7d673"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a862de4f4198d0c44dcf7827340d57ffcb0665a0014142b2d62f353e29b0e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e239be497a40ac72c38442ebe3e0c70b036dd040a57de4f06da68788dc66ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "386156503cf7cb5019b9a395ca69603c61e2dd88f546033077d37850511740fc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url,tree-sitter-bash,node-pty}/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end