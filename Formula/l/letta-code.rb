class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.0.tgz"
  sha256 "52e3ce7c9d24b9fcabb13d73d1fc217805d2a32fe02b9c05cb99817f9ccc6d75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c0011d7e5e550f8c198ff0d116d246c6e061bcfa4f5313cce74820337a0540a5"
    sha256 cellar: :any,                 arm64_sequoia: "2dc4bc9585df13e7e6c49204967051132dcede63b92bda05af1731f80ebe84e4"
    sha256 cellar: :any,                 arm64_sonoma:  "2dc4bc9585df13e7e6c49204967051132dcede63b92bda05af1731f80ebe84e4"
    sha256 cellar: :any,                 sonoma:        "0373a78c75e5b7f8dfd4cc1844d1b68167e4e14586dd48e20c5d8975076ac4f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b62c205b1f7d5ce23cb1cad9f40e5024a2efc3de91cfa8099f247bdbbb0e7e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0c992eb1dfca2eaa33c6627211fc49f20195eb843b19fc0683b86ee44bfeab8"
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