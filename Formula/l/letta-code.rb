class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.7.tgz"
  sha256 "df4ad3d2d1d2a8f98149f31ecc73f366786dcb802a1a6ff789d9af19fdde4e95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9a122c4bc98dbee2812cc6335c8e2ff30bd62f1c5d22f63f16ea0fdda607ec1"
    sha256 cellar: :any,                 arm64_sequoia: "7df49f2e0dc2f47ab07f5602580b9dfc38f76b7682eb791edfaacd65f6f5f74d"
    sha256 cellar: :any,                 arm64_sonoma:  "7df49f2e0dc2f47ab07f5602580b9dfc38f76b7682eb791edfaacd65f6f5f74d"
    sha256 cellar: :any,                 sonoma:        "a7017ae78045c6dc7ff2da769e7a6c32b81f366ef26e6bb4fa29f6d533e90479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c89827e493ce68fbab9c8afaf127acc82c4350264f4e307eba5f1652f4293f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f530a22c7e682978fa8de792e67e74c3df4425c8ac732e6ddb629e73a469e3c0"
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