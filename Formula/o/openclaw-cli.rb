class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.7.tgz"
  sha256 "a4cea9b802d9677dedc083cb3cf388fab00e6aa05dee56195ec1dbf02fbe5da7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e758f57d7c7bd96dded3d42ad0c87212035a0e5ce9637c1ebb70687494902152"
    sha256 cellar: :any,                 arm64_sequoia: "13b535c734dfbad4ec73142cc1e72e91c7b1ea5aecb618553e708c70a0f77f72"
    sha256 cellar: :any,                 arm64_sonoma:  "13b535c734dfbad4ec73142cc1e72e91c7b1ea5aecb618553e708c70a0f77f72"
    sha256 cellar: :any,                 sonoma:        "75ee893a40a50b4e44169a66648069f2e86ce21a70c6fdf9792fa3e3bb6dfd8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb526bab31ccb5e884c7d0dcdcef7bd318a96587ee7fe1c570b2e3eef21968e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0692a1158dea513d40f3f21b70c69f795d6e295e2a73d28fc5306a84b0afcde6"
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