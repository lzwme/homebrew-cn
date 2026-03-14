class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.12.tgz"
  sha256 "2ee324fc0d378deb13cf24be16a3996aec35e27f44d1a58ba9a1ded3afce3d37"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e363b80c868c3fe286b27a67c38a8d18cc8368cd0966c37333dd34e3d92aeab"
    sha256 cellar: :any,                 arm64_sequoia: "888a48022b43564969845ef9c59067d31629afb9204c409a5f1d9558912b8da0"
    sha256 cellar: :any,                 arm64_sonoma:  "888a48022b43564969845ef9c59067d31629afb9204c409a5f1d9558912b8da0"
    sha256 cellar: :any,                 sonoma:        "3d3623ecafb07a111d528cfe0f69af9dae9c333ef4876f01e2b2c76e8890944e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21263023bc0ffb366677f087f31e3aca99418070df23a800a694764a278d6b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "875d17d4f66874d0b024fedec316d9eed0a941a77ae2fad31499f410a4cc0310"
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