class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.10.tgz"
  sha256 "5bdbe5a58c8b7a00745aa56d976e027e30a0cf0f96d7765097f1b02900076445"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "325f87513d961ba387468077745eb2169f6e18b550181cca1ad67226c2d2ac56"
    sha256 cellar: :any,                 arm64_sequoia: "6c922654ece1a124a8dba4dd19f81c7ab0c457be24886f5d4a18a9da254e5abc"
    sha256 cellar: :any,                 arm64_sonoma:  "6c922654ece1a124a8dba4dd19f81c7ab0c457be24886f5d4a18a9da254e5abc"
    sha256 cellar: :any,                 sonoma:        "5c8e985e53981a238472f53eb6298f393f06f3388420efff631edb7472a8e2f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7e26b391997b8eab8c49d9eff81ed37991153d5fac4e48eb80ea852c1eb1ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd397e1fc14a5ba096bc69db225063fce8e689663acc6b653876a276a465701f"
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