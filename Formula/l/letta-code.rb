class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.26.2.tgz"
  sha256 "f53dc4e965c52281c8ccb46d6bcd137d0f794501cd4897cbfd39ebc04fe0d0b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b5c221107877151a8769c23054999d669ec22afd8731f11ec7ca49b98522301"
    sha256 cellar: :any,                 arm64_sequoia: "0aab1d4aacd5a044b0d72475fc925b4d59e166ba4de15b3cb973652c75476bb4"
    sha256 cellar: :any,                 arm64_sonoma:  "0aab1d4aacd5a044b0d72475fc925b4d59e166ba4de15b3cb973652c75476bb4"
    sha256 cellar: :any,                 sonoma:        "5a486b9d636d12e53f708b66eb7ede01c3600c6baf417408d2ed41d81df3745b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59768bca2175a1148671a43149179f4c7c8cbf00ff4792fef430670634591f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3acaea3c7e5b138f67c417ebc7c6928e798a0c4b80bc521ecc775807147c7516"
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