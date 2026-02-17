class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.15.tgz"
  sha256 "653a3f32ac8beeb38da77a763851694ff96146433234170c590584842e0a985a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d959523d4a8f73f1348bc30e0d1eab5f1ac6e5d1710baa6c6bac6473c435b36"
    sha256 cellar: :any,                 arm64_sequoia: "1532abfa3ad909d7cad54f259b3c7e98b77e53d0f7b6038554d2e529178bd244"
    sha256 cellar: :any,                 arm64_sonoma:  "1532abfa3ad909d7cad54f259b3c7e98b77e53d0f7b6038554d2e529178bd244"
    sha256 cellar: :any,                 sonoma:        "11f0e5ef4b4849da4b0098123acb98b06e9c1514d7ed41cca719cd47485bef17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb1e28663bad51b2648764d6f42a5206377634e58d36d8c370e72dd5e861f0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dba259f482f88d0d5b89b32339c10a5c71cb254c477695bafffa97edf3923b50"
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