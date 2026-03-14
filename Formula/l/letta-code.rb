class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.18.4.tgz"
  sha256 "6ffb6d5e60b078550883689903f575fafd51870401a3b0c84cd6e4a98bf826f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80051484bcff0df2e0cb74e92cb4f05b612613cf7393042319bc6f655ced3707"
    sha256 cellar: :any,                 arm64_sequoia: "6086da590b33a36d4e4a1510af5cf402071432297e3c0d82c97879ae00427963"
    sha256 cellar: :any,                 arm64_sonoma:  "6086da590b33a36d4e4a1510af5cf402071432297e3c0d82c97879ae00427963"
    sha256 cellar: :any,                 sonoma:        "efa3276aeca12a66fe0d58ef135550392982da57d87f6fde113961e2cc356beb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "437f3730f60bc825d81eeb02a0358e3d2fa1fee8912039fe66dbcce7be100a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84b853b76a99cd1a3ab63db6d0d9346409f9acbfb9afd2bd4313cd67b0d1d3e3"
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