class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.19-2.tgz"
  sha256 "296cc537462a2ff0b9b2a3c4b7c5083171a13523c4c3ba82ca10ef1c5b915c71"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "083e45332daa19d73dee707ed09fc31d06788bdad42713206ea4aace18f17a71"
    sha256 cellar: :any,                 arm64_sequoia: "e7a9dc2144669dca0ba0544694fb6fa3109bba0afb07f9844678afa510dafd19"
    sha256 cellar: :any,                 arm64_sonoma:  "e7a9dc2144669dca0ba0544694fb6fa3109bba0afb07f9844678afa510dafd19"
    sha256 cellar: :any,                 sonoma:        "81da45b579cc8994ef984e22d500349fafba66c886ddde721281e5e408776761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d62cb22fc1c7b040bae6ab73e3ac3bd7b04f8cbb059e6de952b8a97e92f1856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1958168ff58dc3e4b967a62285f71a21cf49a90ab1b428fa298551bb9d8cdd"
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