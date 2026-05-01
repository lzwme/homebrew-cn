class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.12.tgz"
  sha256 "85687b6ad4116688d16696fab638008efcb77cfb2b4657f5c0e0956f684c6eb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "908275aae07eeaa914e9ec2dfe785286ca512deb2a328a6d71ade8d536df159c"
    sha256 cellar: :any,                 arm64_sequoia: "e1f1a05bd615c6a5c69d559c22313cbf4620b10fc6a66673d043a21c11d8d873"
    sha256 cellar: :any,                 arm64_sonoma:  "e1f1a05bd615c6a5c69d559c22313cbf4620b10fc6a66673d043a21c11d8d873"
    sha256 cellar: :any,                 sonoma:        "0bd31a821b9885e6b5c39d7ebec1e9d9b5cec726cbefc0c2449d3c9f19b8b38c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e4a3fc825bf81dbf3fb196cdca901d2dc21cde8b86eaa137a95bada62dac970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e01b332c5a697bf76fecdae4a30a25627e581cb0afa2b566be6e04eb28ade1a"
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