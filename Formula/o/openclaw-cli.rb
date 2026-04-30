class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.26.tgz"
  sha256 "a1c0b9d417003b302d6c63bfc93d015784ad4b6a4a1360d1814ee1f5928ce3b4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2cca98d4abeba163e6ee1bcf10b4794bd9f5a9dea852fee8b08ae14b922a1f8"
    sha256 cellar: :any,                 arm64_sequoia: "57679ea4a8391de6fa37cc1bc5ff4ac127a4eb912bfcb699d7f8f16fde0f13ae"
    sha256 cellar: :any,                 arm64_sonoma:  "57679ea4a8391de6fa37cc1bc5ff4ac127a4eb912bfcb699d7f8f16fde0f13ae"
    sha256 cellar: :any,                 sonoma:        "d5b4e3446290b734a3834996034f4a6159fa0390c3d69410a1531ce8b6115dd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86e10c412fccbe432d14b28aa120e76f58370716490627d14c85a3086293643f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0874717aac468d52da2425b93e970e22f4449de65512b12f02cae41f292eb8a0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # sqlite-vec falls back cleanly when the native extension is unavailable.
    # Remove macOS pre-built dylibs that fail Homebrew bottle linkage fixups.
    node_modules.glob("sqlite-vec-darwin-*").each { |dir| rm_r(dir) } if OS.mac?

    # The bundled Discord plugin ships unresolved nested dependencies and a
    # prebuilt macOS arm64 module that fails Homebrew linkage fixups.
    rm_r libexec/"lib/node_modules/openclaw/dist/extensions/discord"

    # Remove incompatible pre-built @node-llama-cpp binaries (non-native
    # architectures and GPU variants requiring CUDA/Vulkan)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    llama_target = "#{OS.linux? ? "linux" : "mac"}-#{arch}"
    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?(llama_target) &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end

    koffi_target = "#{OS.kernel_name.downcase}_#{arch}"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != koffi_target
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end