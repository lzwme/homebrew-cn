class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.6.8.tgz"
  sha256 "3200e398b731104fe34e50d198adc45f329b90d0aa944ccb1a912ca53bd44554"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "456a423b3351a324d7cd4ff61073c3c5775ad537f00448566c66b1e698419745"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "456a423b3351a324d7cd4ff61073c3c5775ad537f00448566c66b1e698419745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "456a423b3351a324d7cd4ff61073c3c5775ad537f00448566c66b1e698419745"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed7ab6a30a6b5a19a88e3081f405f227808b9e0f10edb85ce3a2f3f0dc463ae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c99aa0caf26af9de39d707cb392792e4b46a6a504e5f0210d18523f0b7bc82ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2e848b5e57a8b95dc5cab6801446876fabace16da1068e8266310a9c31030fd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"

    # sqlite-vec falls back cleanly when the native extension is unavailable.
    # Remove macOS pre-built dylibs that fail Homebrew bottle linkage fixups.
    node_modules.glob("sqlite-vec-darwin-*").each { |dir| rm_r(dir) } if OS.mac?

    # Remove incompatible pre-built binaries (non-native architectures
    # and GPU variants requiring CUDA/Vulkan)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    target = "#{OS.linux? ? "linux" : "mac"}-#{arch}"

    node_modules.glob("tree-sitter-bash/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != target
    end

    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?(target) &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end

    os = OS.kernel_name.downcase
    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end

    node_modules.glob("koffi/build/koffi/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end