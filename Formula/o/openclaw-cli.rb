class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.2-3.tgz"
  sha256 "a0e4862c4e56a8386d7c030121ae300c7bff1a4b76d4f8a48b5444998d169f38"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11a0cd662bc3dbbd0ad35ace48e5930f87706c67a5c7368532b640d67bc6d6f1"
    sha256 cellar: :any,                 arm64_sequoia: "68e08c52106c4c660928ecf38b1f467948f8d87c352b844a6178744e70ed858e"
    sha256 cellar: :any,                 arm64_sonoma:  "68e08c52106c4c660928ecf38b1f467948f8d87c352b844a6178744e70ed858e"
    sha256 cellar: :any,                 sonoma:        "0f7ce5e7b40ffc578d187e5ff879300d6b67e92ece2733da1d516500ed689215"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14207e68d6e87806ecd0cf67845076e3b02db91c7301296528593c38f9ec429c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b4dfb36878e1abc78f0687c0e078560b986fc81104f6e59956d08a202d518d"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end