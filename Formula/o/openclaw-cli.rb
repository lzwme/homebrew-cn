class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.24.tgz"
  sha256 "e4079634e040f0f098eb1963360975645a8954c87161c531f0c1d52a2f5f5429"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "60f7cfe0bde174941dfb67df9ea43e13f7b9183d459b5682d24ca09b44b0ba3a"
    sha256 cellar: :any,                 arm64_sequoia: "cd53536c67f6a838e2ac25b3aa4d59afd2060c0f41a3b442247935d368168d29"
    sha256 cellar: :any,                 arm64_sonoma:  "cd53536c67f6a838e2ac25b3aa4d59afd2060c0f41a3b442247935d368168d29"
    sha256 cellar: :any,                 sonoma:        "26b84acad2b62acf56ddc76a038f6958b5f44dd32ffca3aac42c7001589530b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a3fbaa90d061f74900d5f535f3702ae562db9d3bca2b42a834abbbea5efabe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4dbd911244e7ac031237b7a042532aac1a179d954682585c4dde3e1965ba7e"
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
      rm libexec/"lib/node_modules/openclaw/dist/assets/matrix-sdk-crypto.linux-x64-gnu-W0MyW8nQ.node"
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