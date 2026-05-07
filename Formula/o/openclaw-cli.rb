class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.5.4.tgz"
  sha256 "a843f2ab3823a9216ce4f9f4ae09d69466a1b1544dbc3a027af0567ab6b52e90"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b296f379e969222d7a2ff62d02d644e288fd52ad7d5f8bace8ea98f7af1b781e"
    sha256 cellar: :any,                 arm64_sequoia: "2f61e23d7e4b4eddbcf057e80986f763a895811007b45ed06acaa0e656afdf44"
    sha256 cellar: :any,                 arm64_sonoma:  "2f61e23d7e4b4eddbcf057e80986f763a895811007b45ed06acaa0e656afdf44"
    sha256 cellar: :any,                 sonoma:        "29deb0485478afd17f62e708258ea578d2ff787d746318c91a49aef7f56d9ab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fbc48c9b4f3cee1c959462b67ba58140955af219785466771f6f59261cf9568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb3f14f72fd38f9df217884d7d067096ab4baef28b94ecea8c503996ef7756f"
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