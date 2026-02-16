class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.14.tgz"
  sha256 "eecbf4565a1e71df1e2f6c9dceaf0192d59fd11b59fa68ffc5cadfea546db7ef"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7113158537934c3c6b43926f6aa1014bd4e1b5e46b3d1ee0d907758eaff5b3f9"
    sha256 cellar: :any,                 arm64_sequoia: "685410171b5d63cede5b564661516e779c0c282724dc7daf23b50015e550930c"
    sha256 cellar: :any,                 arm64_sonoma:  "685410171b5d63cede5b564661516e779c0c282724dc7daf23b50015e550930c"
    sha256 cellar: :any,                 sonoma:        "12cf9cb376afbf776d97ac56b455b306e24eab2a269500893d88e638ad37cb48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "319985e01860538fed6cc5727bebe465ede923aa09c4192b8753a681ac217372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29a4c027b2ca152ce7d100e57be943544fbb89e8d792b4812889c9851dd8d9f5"
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