class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.14.tgz"
  sha256 "1f60378e63b57224f695f1a1a15f1ef35a6c5f569c5510c5d92a2cdb2e8ff59b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f41128172d35fb5557101485f1f86fb85dad950708fd2eadff0697c7086d1c6"
    sha256 cellar: :any,                 arm64_sequoia: "24156ca34c59916ff5ae201e257f9c787bcfda6b22ba256e8619c739fd4c58d3"
    sha256 cellar: :any,                 arm64_sonoma:  "24156ca34c59916ff5ae201e257f9c787bcfda6b22ba256e8619c739fd4c58d3"
    sha256 cellar: :any,                 sonoma:        "3b94064857157fcc37512767b14d60a7ce5fb0b8c8b45eab7fde95c4dc2be726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7665c9a2eb1a5d401ed4af5b9c0e9b9fa794ddb128e3cbf9bbd3d694d6d5d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee0ae8214eb594d05b1582d98f795ee4bda7a7c0720566711b38b19891130a31"
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