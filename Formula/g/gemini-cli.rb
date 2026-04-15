class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.37.2.tgz"
  sha256 "b06771351e7f13e7233b6a6e67c61b46eb3de6f716b8d26df0d98e6d5807f984"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdaec2a0a6204a80eeab0f5d093432c0100ccb70e1a0839d45914f824ab09f56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdaec2a0a6204a80eeab0f5d093432c0100ccb70e1a0839d45914f824ab09f56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdaec2a0a6204a80eeab0f5d093432c0100ccb70e1a0839d45914f824ab09f56"
    sha256 cellar: :any_skip_relocation, sonoma:        "34b856702584a4628d8aa6c47809a60f6582e06b8e396fbed67b0c3ba16109d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e92651ad0c675eabe15474a01b8d53f19bf95827add2f5c6e93ebb3ef62aad8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "962510c5517b4a9076a2eba0f4b8259aa5b3e4e29c3c17c4093b93707e5a03b7"
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