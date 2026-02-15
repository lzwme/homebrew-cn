class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.13.tgz"
  sha256 "52a6d49b5dbfffd20ed8540dac438bc234c96cd5a59ab9c012e1a63b017198c8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c028889550870afa251c3ffc298eb61eed1aff571c24503c14ef778059c7940e"
    sha256 cellar: :any,                 arm64_sequoia: "3b701f6eb116fe784e4f4047843c71d66cf6f012ba272060b02aeec2c922ac85"
    sha256 cellar: :any,                 arm64_sonoma:  "3b701f6eb116fe784e4f4047843c71d66cf6f012ba272060b02aeec2c922ac85"
    sha256 cellar: :any,                 sonoma:        "a301a4e9084f0bfe03cc25d1fc775202711c8a03b9950ce2841aceae56a8e115"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1f159428253dbf00b0c673dc7032d17d66ee2ce27b923fc110b4cacf7636d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9436ee05dfb9f0a279a63305333d944f847a5676d098bc6dbd4b00e187bc3833"
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