class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.11.tgz"
  sha256 "4c6641bac62ce2ccb86d8df2d0252dc2a4769fe3ddca12c1f1ee1013ebd65dba"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad8c937f5a8d34ac03a47bec92d3e6186af2982d8364cb97ac8791a8ec62e460"
    sha256 cellar: :any,                 arm64_sequoia: "73e8331ad8bcfc10c74b641ba856274dbce65bfb5eece65adc3f72682a63979b"
    sha256 cellar: :any,                 arm64_sonoma:  "73e8331ad8bcfc10c74b641ba856274dbce65bfb5eece65adc3f72682a63979b"
    sha256 cellar: :any,                 sonoma:        "b79abd1d0b2eb34bd8259717a3357c9c408115ab5b13ac2a529cd1adfd5628bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01d66ac2905acb8987daf10c9b7ed6ae34b97a1f496189159b39322f70b3784f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf7cfb8c8610aaeab91164977a64aac6e3a7539d9197684b7c3e4f002072629"
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