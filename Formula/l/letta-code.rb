class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.9.tgz"
  sha256 "ab457019390bf0b775edf3b4480160b2328aaecc46590600f174faf8a2e36dfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e755c5f955a5939f34c3ba82cec4874f0e6af049de96cfc3dd446a2d3519671c"
    sha256 cellar: :any,                 arm64_sequoia: "e9021b8ba36119032138aa314cb5aa130da5a7bd965ff09cfd834f8f07a93d83"
    sha256 cellar: :any,                 arm64_sonoma:  "e9021b8ba36119032138aa314cb5aa130da5a7bd965ff09cfd834f8f07a93d83"
    sha256 cellar: :any,                 sonoma:        "4e86b3b931d94d0a43a987115718312defe2bea385e87c8bffa4056d6fa7faf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49c946ddc9c100569ba38dfe0ca33d898f6332a9f0a6f3a1738b24d165f63a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1ba5d7fd146b514e8dcdfc004493b0b16128543cca53296628eabd2f7d5fb4f"
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