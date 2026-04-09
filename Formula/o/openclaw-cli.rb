class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.8.tgz"
  sha256 "b242bd1200d63a8b133136503af159f3d97d9e390234550f768159b0ab783011"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9eca48558bd644368d9a581cb60578a8c539b4f09d8c0093a68af44fa98eefab"
    sha256 cellar: :any,                 arm64_sequoia: "e8cc9b44b4282c20ad8465fb0577d770fc11205ada333c16c56355289085661d"
    sha256 cellar: :any,                 arm64_sonoma:  "e8cc9b44b4282c20ad8465fb0577d770fc11205ada333c16c56355289085661d"
    sha256 cellar: :any,                 sonoma:        "0048dfa02acf23b9ee14b4b71cf046ce6922d2e6b337bc1687d979f248f019ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ded9805c8a2484de938be20a2fb27ca3e512d4958a38cd04900fa36f4bbe389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d33dc48cd78b33107a882664bdfa0ba1ee05ef07bff88027f9866e30d800a337"
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