class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.6.tgz"
  sha256 "63b5948235440880f803b1ab027ce9583e1a585975047d2c24de29c021c86579"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11d03828af96e4299a40d3e1b88803e4bafdd7aa65b79e33923cb56acefa9eae"
    sha256 cellar: :any,                 arm64_sequoia: "92ccf56d8601089dd851b8c788a243acb74ab7555e8c30ee0e51c67dff4b716a"
    sha256 cellar: :any,                 arm64_sonoma:  "92ccf56d8601089dd851b8c788a243acb74ab7555e8c30ee0e51c67dff4b716a"
    sha256 cellar: :any,                 sonoma:        "a547753058d4c166955506222979df5b1a3fb7c72d185611d922790245f379ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0139d37143eba96509f1d4e81a435109ae2c5108659e75d7903879bfdff1279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a44b94e456f7d8bb155c04b270c155c0922644a1fb56b99e0aae8e77087eadb1"
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