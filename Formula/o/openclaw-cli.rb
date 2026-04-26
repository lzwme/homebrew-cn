class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.23.tgz"
  sha256 "f733232008e9768e31b1017b999e391ee27e5e756117944ad5b0120547ad366c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b836436db780cc1e6547043cd1bcc2434c483b94f553b8fc12623813691da91"
    sha256 cellar: :any,                 arm64_sequoia: "e2affafd177b43eca62bc8083b1f79ae7461d843f134b5a722cf4db134ffab0f"
    sha256 cellar: :any,                 arm64_sonoma:  "e2affafd177b43eca62bc8083b1f79ae7461d843f134b5a722cf4db134ffab0f"
    sha256 cellar: :any,                 sonoma:        "5f352a163d31127156f82d83a1bc43d178981400975c54eeca5d4c51804b089e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e90b49566a3f2d391a536ac2f3b6192aa885fe0c877ec04dd54a3536c2d1242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892d838bfbc235a98456948335037759cdff04d53728692a5698986cdb82d07a"
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