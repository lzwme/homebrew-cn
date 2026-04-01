class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.31.tgz"
  sha256 "638a14e096cbd22c57e77f17f1bfb7055acfd1ca039e4b03ebf4ef65daf628e1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e47c3a663d0924bd2d46a27696ff9b998c79dd3bc806693beec4b08cd8ebd87"
    sha256 cellar: :any,                 arm64_sequoia: "5d4e4e620ce0961b621264d48410b32ae973dcb7e02cefafb97fff9eccb98798"
    sha256 cellar: :any,                 arm64_sonoma:  "5d4e4e620ce0961b621264d48410b32ae973dcb7e02cefafb97fff9eccb98798"
    sha256 cellar: :any,                 sonoma:        "79275f92b8327b1248ebd17a6e508e336881c8e3146466d3339054a67fa7a37c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adfe5075e7e42c86b1e1f6035d0d8f60fea48e7979fc63660c1927b4def0fccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15da7fb8466d5dd15f787501bcbb51ab6eb56f0d6257695ff52a6e95a1ffa1fa"
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

    # Remove x86_64 Linux pre-built binaries on incompatible platforms.
    if !OS.linux? || !Hardware::CPU.intel?
      rm_r libexec/"lib/node_modules/openclaw/dist/extensions/discord/node_modules/@snazzah/davey-linux-x64-gnu"
    end

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