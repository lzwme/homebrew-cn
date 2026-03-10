class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.8.tgz"
  sha256 "71cfdc82141c008d82acdaef1af6382ec43769f20e021ed22429ddf885ba6909"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7fe83e114ea1465e988ab7a163e81d9a80d75cc43bf05a654f08c3f2680a0880"
    sha256 cellar: :any,                 arm64_sequoia: "a9454aad4dbcf767bc83185b06e91c46d55a2463465d9d47c5e1d75a702cd552"
    sha256 cellar: :any,                 arm64_sonoma:  "a9454aad4dbcf767bc83185b06e91c46d55a2463465d9d47c5e1d75a702cd552"
    sha256 cellar: :any,                 sonoma:        "154d96c266ae5c4fffaadcbef2765396dcf80382dd2c65700bd65e966eec12cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "626740d68e1b1cef9f75c78aeff8f3cc9897411c33f03f5ce32d49b367c20190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6df639a8ccfaffa636af10e2450956a41fe26ef0f3db53006103e1085c75a4f3"
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