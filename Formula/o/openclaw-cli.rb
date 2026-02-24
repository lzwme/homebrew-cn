class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.22-2.tgz"
  sha256 "d799b7d7f8dc344d1cf2d8307305325346a304f36679ad9a1d5a3f2492118fa2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47bb4cd807e312cd765b128a6601e330fe9edf179f2f3354f131b3df9fc7a257"
    sha256 cellar: :any,                 arm64_sequoia: "2d6d32c1c5dd3404d36d20dc17102826bd04e0a5f544e60f75f42864e1a19e4a"
    sha256 cellar: :any,                 arm64_sonoma:  "2d6d32c1c5dd3404d36d20dc17102826bd04e0a5f544e60f75f42864e1a19e4a"
    sha256 cellar: :any,                 sonoma:        "59b1bfe28b2336eba48c7238fb454f5d313c8b0fd237b1f856af5e18654aea97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb2483a9789b61b30120c8529f1a75b941d3de7ef5795e49a42323ead6bf66d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "230bd2f5e82fed30d9339d62162cbf3a3022f0693aa74004ee5c17a9e31afe65"
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