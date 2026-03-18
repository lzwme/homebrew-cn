class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.0.tgz"
  sha256 "5891d61057e3054bfdd99e1f5e14b96ce19cda74a75c53f0beac586e796fd1a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c3a40a182f268934abd0f4f30362b6f1a3a7f797ffa5a86d57a4e636da00a99"
    sha256 cellar: :any,                 arm64_sequoia: "fd1c5cfac7c3fe40df9bb6558f2174b01e36b2e514c89c85cc8488eee400e326"
    sha256 cellar: :any,                 arm64_sonoma:  "fd1c5cfac7c3fe40df9bb6558f2174b01e36b2e514c89c85cc8488eee400e326"
    sha256 cellar: :any,                 sonoma:        "968ef33efef7775a7ac1e6765fa117de7f2dc52edb169bc89e5932992bee4ed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2488115c8306c9fd3675cd1c4d96bbc05ff0ab1ea899404045fb954fed2b78e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f68ce179cc080cb344099e37da2a9673de8a9411dbadd15766387eb9cc8ff1b"
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