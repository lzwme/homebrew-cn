class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.5.12.tgz"
  sha256 "1cae4d1d4132e5fd548478ab3ad3c578627a9c78e37e67379dde7659c674bf1e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "511320ae345319f232278d63d715320cfd20051c3bdb74c6bacdc8b2f16919c4"
    sha256 cellar: :any,                 arm64_sequoia: "48293827e0983ffd0b5a516f58716c6086215a4cf821a7ba2e31c008f78fab29"
    sha256 cellar: :any,                 arm64_sonoma:  "48293827e0983ffd0b5a516f58716c6086215a4cf821a7ba2e31c008f78fab29"
    sha256 cellar: :any,                 sonoma:        "0ad431b065b83e68154c54a8c4d3ca9e5297bb144cc4e59c4568612016be9da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c89072bf63262475b7ab278de487bb67e0e7ebf76e126fc51e831534b37b2d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d1bc658764060326230899db63f5b61f49d1597c4a36c4f3eada8697f1cb5d"
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