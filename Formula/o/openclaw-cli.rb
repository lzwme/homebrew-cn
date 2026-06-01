class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.5.28.tgz"
  sha256 "2f67aa242bfdd58fd1bcd3fea46df12531fb34b3c6987d98982b2020d0e4f905"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c68cfff7d43337220ac8b5f3ab2b583171e9002a1222ff6a8bb934f728a03808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c68cfff7d43337220ac8b5f3ab2b583171e9002a1222ff6a8bb934f728a03808"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c68cfff7d43337220ac8b5f3ab2b583171e9002a1222ff6a8bb934f728a03808"
    sha256 cellar: :any_skip_relocation, sonoma:        "af1dcf66a7b227f0b916eaebd287d7535f412cf62a40d661debb9ed7f65e6c67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b6ba047a49b52fc31bff2c2af766c9abc6abceb727c4ab45255b93e0c7c1e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "953e55da72fd3e21f1121ee946bd8ec6888f9b032270ffb7bd63e8dd8f70636e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"

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

    os = OS.kernel_name.downcase
    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end

    node_modules.glob("koffi/build/koffi/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end