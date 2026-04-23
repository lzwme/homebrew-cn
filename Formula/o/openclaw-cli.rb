class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.20.tgz"
  sha256 "ba599fa11b7d057a6cf80ffb62b84c9a8b999a7e949764827bd921650a090f3c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b2f4f2d3794d75aa40b91d924003320af8e998ef2b05ce37a78ee94d95a4ea1"
    sha256 cellar: :any,                 arm64_sequoia: "8b6c86ce7dad7c42a9fff61f8c0e61b2ab26497ccde2a4a708fbb8c156da7adc"
    sha256 cellar: :any,                 arm64_sonoma:  "8b6c86ce7dad7c42a9fff61f8c0e61b2ab26497ccde2a4a708fbb8c156da7adc"
    sha256 cellar: :any,                 sonoma:        "11d2fe05e35279d1c0d684872aec44054e8b67c2c7cb611229870547ea631c8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa20f28067d337e3c07f59d58f346eaafccad3555275121bc723eaef2d8de0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d26f90fb92a0a7f87d2d9b75a5953ce8e5aad3e1fb5e3d7b36f3ff2b10983fe"
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