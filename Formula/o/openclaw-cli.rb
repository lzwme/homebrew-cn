class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.1.tgz"
  sha256 "c4851a440981d67b7fe40fe578e09735bdfbb8d5744ee8bf4481eb861e01f618"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a668aeb458f52db8ccd38f0fd3ead82dabe0325f5c907e63ce68e5a4b5760e0"
    sha256 cellar: :any,                 arm64_sequoia: "e9beee9440a0bceac04da92233a2d2cee56b8770e37163e304cf96c23456f981"
    sha256 cellar: :any,                 arm64_sonoma:  "e9beee9440a0bceac04da92233a2d2cee56b8770e37163e304cf96c23456f981"
    sha256 cellar: :any,                 sonoma:        "146a81bffa099b5222d7d372baa890ff0ea9c4b8f31eda829b5a0941a4f000b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d5cb21f3fadb6871a1ec0db7a45c20b7689ef7aa5e65925b747cc499388d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8be24fcc4ff8d3fe2691e95da2b98fd8c90f61dbbe7555cacfe4064f9da80010"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # Remove incompatible pre-built @node-llama-cpp binaries (non-native
    # architectures and GPU variants requiring CUDA/Vulkan)
    os = OS.linux? ? "linux" : "mac"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"

    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?("#{os}-#{arch}") &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end

    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end