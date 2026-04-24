class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.21.tgz"
  sha256 "4c0a43cd712e66dab146d5b25551cd24ca10b6c75a6218c05365f6dd292bffb2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2315c287b623ec56232d49eb0280782774d06a60685928a5714d3af306ea5cac"
    sha256 cellar: :any,                 arm64_sequoia: "9440d0d88fbfd6babc6d394f64d8ce020726e0bbac724701cdac80ba6065053e"
    sha256 cellar: :any,                 arm64_sonoma:  "9440d0d88fbfd6babc6d394f64d8ce020726e0bbac724701cdac80ba6065053e"
    sha256 cellar: :any,                 sonoma:        "5cc8228498eede12ee0e31b7b407201dd69bc463eca97eaf84955df40e9f6146"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e12f181550df50f4225095cc2b2885a3f0fd7cf1065d2030d6360b19fde6895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87c23b8ed4a7d128464900015c55333c423d39eb7268a4e0091f2bdfc7bfd48e"
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