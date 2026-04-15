class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.12.tgz"
  sha256 "74f903f1d2abe8be3ac5c79498024961459606c4c86601c1cc8dc9a5811a4850"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e1df5c7c4bdec08588c927d9487ad5a191ee0faa8c7d596a47e6bc0d7eb7e12"
    sha256 cellar: :any,                 arm64_sequoia: "0af6cb1be120ebf3b9e1a2fe1d35f9094f4fb6331cd12b1cacb41c19def7ff33"
    sha256 cellar: :any,                 arm64_sonoma:  "0af6cb1be120ebf3b9e1a2fe1d35f9094f4fb6331cd12b1cacb41c19def7ff33"
    sha256 cellar: :any,                 sonoma:        "a965bd1334d7d0ffa183b2b46d2867228ced8a664d2fd6d067d2840f777eafae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf295a5cb43950cf4b342987a978289e8751a8f4cae45098cca7e370d62a5241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eeb70d3db3f408776c6625acb1970db82a059b0cf828f88f45532e7de81e992"
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