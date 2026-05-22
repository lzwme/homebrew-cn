class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.11.tgz"
  sha256 "2a6dd3fe5666a4223b9af204b9db63833f0a90e04c36ed18f681698c878fc5e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db18e08c4be3b8760ce80636e51197ac586e3d694f453150a21ced365780ec5f"
    sha256 cellar: :any,                 arm64_sequoia: "1008e0e4d7468633a1cc6efcdc6332d081210725cbff5627c16db1387bbc774f"
    sha256 cellar: :any,                 arm64_sonoma:  "1008e0e4d7468633a1cc6efcdc6332d081210725cbff5627c16db1387bbc774f"
    sha256 cellar: :any,                 sonoma:        "13c78af54cd7c6272ba40fa779c103ca67130b21a66cb7b2002e23adf6d9373e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c267bae94691d5bc9482ce49d7c711deee9ff952d8733fa477ae5369e530dcf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f4d1a3cd354e8d6fa50cb59cef05a0c3dcd9d15547c0832effaf04fb6d44edf"
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