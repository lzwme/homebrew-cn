class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.1.tgz"
  sha256 "41ffe85b4f3dfe9666132153614e8d1dae7f3220b82ad59d9bd5796f71d8ae50"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "476fdb652d2ef6aaa70b958a4a9352d47c5e59164750a5c72c877b61f58793ab"
    sha256 cellar: :any,                 arm64_sequoia: "9e6bdc9acd98d4f7165cc7ce3d5cf059ebcf4b12805a87665e891626e00585c8"
    sha256 cellar: :any,                 arm64_sonoma:  "9e6bdc9acd98d4f7165cc7ce3d5cf059ebcf4b12805a87665e891626e00585c8"
    sha256 cellar: :any,                 sonoma:        "ca9f52848342d0b9fcebca468d8b3cb6d6576a774697d8e92b75e038441cf660"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e03ee090565e7fdfa88f981c766ce2e588dff3c45d6f9e949dd8785de3e9ffe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd5a7d36c871b8d4a1b4947876b5b917307c9e48d1775c49cb40890712196ac8"
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