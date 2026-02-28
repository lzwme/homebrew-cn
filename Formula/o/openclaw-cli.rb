class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.26.tgz"
  sha256 "b021c79864a673e86598f49ab3ad37c73ef923e54fb9b2feb9daf46ce5d3e860"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ce153ad3c1c2fac8d5fc091aa077aef22d98001ef647ea1fe03c5c7720022a99"
    sha256 cellar: :any,                 arm64_sequoia: "eb03e2c76c66277e24bd02f27ee719061c84d7a31193c6e7717f20215a35989d"
    sha256 cellar: :any,                 arm64_sonoma:  "eb03e2c76c66277e24bd02f27ee719061c84d7a31193c6e7717f20215a35989d"
    sha256 cellar: :any,                 sonoma:        "d4536fd3205cb0ff9a3d082e88116a626179993e82de7329582e2ef11be78bb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "193b40a1f8410ef0e6d0a71b4c1bb6c3ac835d04b059c665d7f79c063ad4330f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "165ed0c4554f4756d334e0a9cc0cf0f7b4a45992bde99acf9f8729a6f80bc8f6"
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