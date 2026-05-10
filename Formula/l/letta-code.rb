class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.3.tgz"
  sha256 "1c11889227c3a71d04a64c1c0e89c7efd9757f1969e75caeb31ca90d75fb6434"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19e05dac5834f1fa40e461b9f0fd1aa6bc031929aa94ccaba412a593d979c785"
    sha256 cellar: :any,                 arm64_sequoia: "57bddb10080fcbadef8d1f8c2eb99f286c4418c23bf93a846fcf618b6635549b"
    sha256 cellar: :any,                 arm64_sonoma:  "57bddb10080fcbadef8d1f8c2eb99f286c4418c23bf93a846fcf618b6635549b"
    sha256 cellar: :any,                 sonoma:        "d5b1fb021fe683223d07e026e698ab86fb394621a68f78ecc41a9c33ac3c6a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f39e9a6bdbaa2c1f10dbbf43cd42414287736b12664d599d9db95d48d8b1aa77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d0f0edf17b6d04c7e952564148279b6e344fd8e7199cb2e095665cdd9bec9a0"
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