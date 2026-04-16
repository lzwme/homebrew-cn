class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.14.tgz"
  sha256 "b7b641d4e4bdfa9dcb6fba934d452e963ea3c6d3128dcd8cd46a092a74c33cba"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6af1669ee83eea68a4f1895c200391395aec5e048d1b8f06349fed0e47e75eb"
    sha256 cellar: :any,                 arm64_sequoia: "a71c755373a84c62341632998ea29e8a30d5c9c13c6af4234ca6dc3a498b4929"
    sha256 cellar: :any,                 arm64_sonoma:  "a71c755373a84c62341632998ea29e8a30d5c9c13c6af4234ca6dc3a498b4929"
    sha256 cellar: :any,                 sonoma:        "99c52aa8c9357f9202b5eaf881dfc608688a764cfe9f2052cee6db071c461f03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01b7f372abf4418694d32f97a015c8ca6932d55246826367b8103cb6f3c21be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f070bd6b5d38f7799d7c6dd18045311ca34e05c3ce8cb9189a9aab958710ed6"
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