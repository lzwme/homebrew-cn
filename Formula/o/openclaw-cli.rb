class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.28.tgz"
  sha256 "fd709a39f5d14c02f773f37e18aabc0f5180c3737b26f71efa90b06dafc3edc2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9496c2203636f5874ee779579c7226867437cc6ccba32ffb0aa76fc0aa837c06"
    sha256 cellar: :any,                 arm64_sequoia: "0e0bf36d6bded1157ce7f73b9c1a66e8d48209c27dfd63c1781f53e3d83b1642"
    sha256 cellar: :any,                 arm64_sonoma:  "0e0bf36d6bded1157ce7f73b9c1a66e8d48209c27dfd63c1781f53e3d83b1642"
    sha256 cellar: :any,                 sonoma:        "68c30f5e74596ef37d1c93ea280baf44229ccd3e77e50f9767c6013db4a10413"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15eb4fd07836f54e4e695599c73239ae03068c52c11deb71f4d10083b904326e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88310732d232156ddc3166354cab23cbdc749f88dc33be016663f6f5510fe248"
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