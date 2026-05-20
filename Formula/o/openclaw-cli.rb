class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.5.18.tgz"
  sha256 "12223d7ac9dbe90c47c55a57f23854123655463063190f2c5b1293f16fe9e3aa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e710bf0dd793aef271e9236c9dafff00c106fd2920f2ba21ba8a66352e33dc8f"
    sha256 cellar: :any,                 arm64_sequoia: "ec4c8ba5dbc9a9ef2af96380d76bf469c80d22e2b9835e226d467511d08968b5"
    sha256 cellar: :any,                 arm64_sonoma:  "ec4c8ba5dbc9a9ef2af96380d76bf469c80d22e2b9835e226d467511d08968b5"
    sha256 cellar: :any,                 sonoma:        "fb48bbf62cb170f4c25ce5368a79bcde94b94959d3db31cde55b9bc201c92ff2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a89fe321b3d5bf05bb30a4d79d5ec6406eb07d341400708dade6c71d461978d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "557c66bbdca11a1581e57c8ca9007813eb1ec1fee885d9f0b2d1e87d87d31168"
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