class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.22.tgz"
  sha256 "5c055f30846666a42ab509650538f55a1c0e5193f1cca5f9d28bf012d0f6c04e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "631522369c104a1cf5a6e5af3b82e02191b714ad6151ebf438d96830fcce8e92"
    sha256 cellar: :any,                 arm64_sequoia: "c5827e6ce9c042ea1613b8e69a6d04515bfa82d4cf57e0bee9e0bbba5349f350"
    sha256 cellar: :any,                 arm64_sonoma:  "c5827e6ce9c042ea1613b8e69a6d04515bfa82d4cf57e0bee9e0bbba5349f350"
    sha256 cellar: :any,                 sonoma:        "afa665e45463865161608bc979b1aec1bdc6f0f601da7de84200083d658e971b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2757398fbab1b45aa6efeb25c24e4a598275e2ad0effffadcbb6b8ff0d80eb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1dc6c0eac18bb6dfc46d93b472f2b8d505a8f3b32ca530c0bb30a62b3fb590c"
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