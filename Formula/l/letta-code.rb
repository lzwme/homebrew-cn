class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.8.tgz"
  sha256 "d1e5fe54a176c89f05fc8a4746b7835ae010f707e3c27380f642e5f88f9ef045"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5019baabb18a14972eb3b97cf74b8543e9c62f1bf85d313e86fb7b3f52bd7786"
    sha256 cellar: :any,                 arm64_sequoia: "cf23c334a8e33a264ff76d0b4e18816f7989bb79eb9507cbd16f4e35ba38cc83"
    sha256 cellar: :any,                 arm64_sonoma:  "cf23c334a8e33a264ff76d0b4e18816f7989bb79eb9507cbd16f4e35ba38cc83"
    sha256 cellar: :any,                 sonoma:        "5e7eabb18b1316bf0db923f2c0e8cd610ec2358435de1514d963efa31129b2a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59a527d446f1db58efb8a61e7aaea40df28698e3541e68ce53604bc64e1c0414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39be2f542d5a528a3f6786ebc5f237d6d5a718014610ae301cd4aa9829168b45"
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