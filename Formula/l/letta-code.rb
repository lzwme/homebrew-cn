class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.9.tgz"
  sha256 "5c151b0413a6704a02ee17683eb0e810ccaf2172543358adb48a91dfd3cea4a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56724d27f864e7971829346c846776dd08001b127542d6f2960168ca0bc7f17b"
    sha256 cellar: :any,                 arm64_sequoia: "19f541e4550de0c2fe6f8228644fa462a142924052b609ef37d034927296e6b8"
    sha256 cellar: :any,                 arm64_sonoma:  "19f541e4550de0c2fe6f8228644fa462a142924052b609ef37d034927296e6b8"
    sha256 cellar: :any,                 sonoma:        "34ff50767509f27229aa2a1f91897b77070ba455e12828b758b2a33d6eef413e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f9b350b039d2427c012b2eb523da05e3e1b9eb5e86f7250bc3c6d37cfb53e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2a4f5884a14279a669b6b2e5c75aaf34061eaf04359ca6ba5ffb9d6db9eb4e0"
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