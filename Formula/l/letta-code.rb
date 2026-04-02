class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.7.tgz"
  sha256 "3457f5f1344eb23e99aac9e0c063fc33bd04dc3c9d7da58b5ae5310ac5f5b14e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb15fc93d478421eb5049530ed721e09aa2fadbc5cc055b0f5c51842f5f34903"
    sha256 cellar: :any,                 arm64_sequoia: "7e961899373e74a8f30452e45044ff9aa13b33ceae926cf8078301af81fb3672"
    sha256 cellar: :any,                 arm64_sonoma:  "7e961899373e74a8f30452e45044ff9aa13b33ceae926cf8078301af81fb3672"
    sha256 cellar: :any,                 sonoma:        "7b8063a6779f9abec39efb29820603ae30b6fa2caae54d4f18001203572b1e66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "388c08942d8150de1233e1cb5af01b37bf73e309081e8f03d8fee8f653fc3b56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6cf1e66d0687b2eedce73d61dd13e51553e4781cfb9185e813fdd3d1f677c01"
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