class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.21-2.tgz"
  sha256 "d328f8c98b89c8bce06196407f5eeaeb687d7e51c5332daafb30e775ca45b2bd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e03929ffa843dcebcb4590a4c426f8f820dffe2a73418fbeba46d7820a9fdcee"
    sha256 cellar: :any,                 arm64_sequoia: "e716cd5f5a98aa08f5d96c736ef22a3066820047258c8d50154c790ec4c2d720"
    sha256 cellar: :any,                 arm64_sonoma:  "e716cd5f5a98aa08f5d96c736ef22a3066820047258c8d50154c790ec4c2d720"
    sha256 cellar: :any,                 sonoma:        "7e2f4400a61864beabba1b970307e180ac37c4b614119f3f98564d4e8ee644ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a21f192f24edfee1ebcd70d894914f52ca4c0926d46c5899a9411d52e393f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3589a2f667d5fe3bd1686b707a251577d321153c8876e76106849b50c15ae1d"
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