class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.38.0.tgz"
  sha256 "d4c5e697bdd51b30d51778562d90887b8e77e5580d249fabdeecffb6261b3b06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4414538a1316e5a98375ef76881dc79fc4f4b1df0843d516411775b70612fbc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4414538a1316e5a98375ef76881dc79fc4f4b1df0843d516411775b70612fbc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4414538a1316e5a98375ef76881dc79fc4f4b1df0843d516411775b70612fbc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "71c70ce60bc85d1d2297047a5540453c04d2e267e4f51f63655972718648cc9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d86dbd05aeda04a926e081109e5b80300cb5d0a8930d09aeaf6e5c213277c64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91760ca3f17c3adeba72786a46a9a4a7f21072b0a44ba74959b9e97490b68d01"
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