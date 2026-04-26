class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.2.tgz"
  sha256 "2c4b97aa49d3da72576c44941136e9a59f963a5b82bb98b439249efb7fcfb714"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "998b949d6ca0c43bf08e053f9a4f5ea4a51aaa0d27af5151c1a2e03f679c73b6"
    sha256 cellar: :any,                 arm64_sequoia: "a95b020805dff88bc7541de090ac0ea8338df5d47ae528959c09cd1964791fb1"
    sha256 cellar: :any,                 arm64_sonoma:  "a95b020805dff88bc7541de090ac0ea8338df5d47ae528959c09cd1964791fb1"
    sha256 cellar: :any,                 sonoma:        "cd48ec7ace51dd31c06dba9d731e12f3f2f504ab4d5e24c9c0854186027c3c82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee3a15b2f9cc07d69c33542afb0c4364dfb7d659b558797c703e254e2309145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8884ea0dc4150dd57f36f39bd3713a2b1b5c8006556ba3a75d8bedc842128f7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end