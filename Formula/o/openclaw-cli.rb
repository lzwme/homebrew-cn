class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.25.tgz"
  sha256 "a31f43b6cdafd21f67fd84c20997a7e067795cdaf1442865383a90c453c9a23d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a31c970d9ce5868480c8b75df8d13581bc72ad9c5f876874a766aab8672bd95"
    sha256 cellar: :any,                 arm64_sequoia: "6c21743fe2e5a7386dea954fbdb0d0f676428ea91ca4e21d084260784f8014d6"
    sha256 cellar: :any,                 arm64_sonoma:  "6c21743fe2e5a7386dea954fbdb0d0f676428ea91ca4e21d084260784f8014d6"
    sha256 cellar: :any,                 sonoma:        "22feb2aa5688bc4de54105c70b71ba937d5d2c40fd218dd390dad1efa35ca843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a64b6a9c1edb081873822a8f649836103b34010882c059242066c73f928b901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19b9aeae42b7711e7c58b3618ec802c5d4b0da3ed77b56c84d91296077dba601"
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