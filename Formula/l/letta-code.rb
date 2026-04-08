class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.17.tgz"
  sha256 "23e40a49ce4c11575fb964bd0126784c2b5232fd604d2b29370f2502b261e8dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b32f52e44173cf5b7138dce28a57233bf62a157de30e40c7f47f5270f04e79a"
    sha256 cellar: :any,                 arm64_sequoia: "ab4c1bc2afe3cfdffa2efaef2b0ac4dcacfdf65e849360d3cf5cbadb9c10eccf"
    sha256 cellar: :any,                 arm64_sonoma:  "ab4c1bc2afe3cfdffa2efaef2b0ac4dcacfdf65e849360d3cf5cbadb9c10eccf"
    sha256 cellar: :any,                 sonoma:        "c2b44bacd5c786723859539982e3e0199978337f0f0594447ef7a3a9d30633f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53cbe607f28da672eb1bc084df1c56c270c932af55d41b5c51231715005b4a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822f4a79f070476f16f6ccd06a59be85e03eab5039a3bdbc586525d34ca9a813"
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