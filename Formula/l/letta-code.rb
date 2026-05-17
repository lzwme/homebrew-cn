class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.9.tgz"
  sha256 "4300ccc43016721eb72fd658321a90ca0d5733d2572d1bdf8627f568635b8f50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6afb0af7d0fcfe37771c36188e31c54c667f98acfd70707829a31ad7c1b8b6f"
    sha256 cellar: :any,                 arm64_sequoia: "9c7522d317bbdafc17a100c671bf28fcd09ae14adde78446106496bbeef311b0"
    sha256 cellar: :any,                 arm64_sonoma:  "9c7522d317bbdafc17a100c671bf28fcd09ae14adde78446106496bbeef311b0"
    sha256 cellar: :any,                 sonoma:        "66126ba0e84e120edb222b87bbea1682eb8a500024417dfb6752840a96a740a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2277895233ba8d2904acfab3f01edf7b0e9dee42fffb646026a7d331e90b610e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80fabebf447b26070a665c2422e45c4fe9fd27961fef84e80e795889cb759d3"
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