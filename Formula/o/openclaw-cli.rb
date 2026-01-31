class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.1.29.tgz"
  sha256 "e6d895a668c0f3a482ff835edfedbc2607426ecbe08b66c0e47a95e5feb82e68"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "768a5e7b2426886ecbcfc03875b7bbd00ece6b8d28334cd9105c98a3e89e4310"
    sha256 cellar: :any,                 arm64_sequoia: "80de27f7447602ba53a36150874c6391d18fcb4cbd4eed7310303c06b3d131a1"
    sha256 cellar: :any,                 arm64_sonoma:  "80de27f7447602ba53a36150874c6391d18fcb4cbd4eed7310303c06b3d131a1"
    sha256 cellar: :any,                 sonoma:        "34af58403af4302be49f364bd3c3476ce6bb60a18e4021240b1dd3129ca909ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bff150f0b0ee0c306e59f66f483ef8b292f2e172e9e65aae22e557f9a0a80bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "898a69ad9ddfb32b0ac154f990642b9fe36c35bd807f9b88be4a2da5833582ce"
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