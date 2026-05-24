class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.26.1.tgz"
  sha256 "e43c472f7b5e98395af3ba58aba0373fca032267d56fa8a31d86f7342786dad1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22f0020aabc797940fdf864387b3130202073ee52a606bf5e853d10df83ed28a"
    sha256 cellar: :any,                 arm64_sequoia: "d74f2d61512db3f823bcc0d09f539a97c0eedd8658abc4e3fa2b74e012cd9759"
    sha256 cellar: :any,                 arm64_sonoma:  "d74f2d61512db3f823bcc0d09f539a97c0eedd8658abc4e3fa2b74e012cd9759"
    sha256 cellar: :any,                 sonoma:        "b21fc1c97ca7eb9eb7789de7d0047335cf07e273975e46186357b96b8280d0d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9739afde0b6a4fe4ec6830eb61a393d759171b626094fc340878049542a21a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3613d4f9509956011695e2014cf320730d0541d1ce0a2413f5eb23e33ea70936"
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