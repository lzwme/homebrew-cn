class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.10.3.tgz"
  sha256 "761685d010d96645d1deabe19299ecde263eac3f2489a17322f48c461a1130a5"
  license "MIT"

  bottle do
    sha256               arm64_golden_gate: "a083f5ccda887bcae5fcdd1f31fd9e81004ea261c49349cc00c62cf1c53d1138"
    sha256               arm64_tahoe:       "a083f5ccda887bcae5fcdd1f31fd9e81004ea261c49349cc00c62cf1c53d1138"
    sha256               arm64_sequoia:     "a083f5ccda887bcae5fcdd1f31fd9e81004ea261c49349cc00c62cf1c53d1138"
    sha256 cellar: :any, arm64_linux:       "539ee2a1b4d13b7e225711dbbae6047eb96f37c033bac9137a9c2ff741a86420"
    sha256 cellar: :any, x86_64_linux:      "8177bfb60ae1feaf7f9b423597482dc2d80305e0ad1bb4b174f87da80f5fcc8a"
  end

  depends_on "node"

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # `--ignore-scripts` leaves a marker that makes the launcher write into the read-only keg
    system "node", libexec/"lib/node_modules/openclaw/scripts/postinstall-bundled-plugins.mjs"

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

    # Rebuild the X11 clipboard helper against our `libxcb`
    system "bash", node_modules/"@earendil-works/pi-tui/native/linux/build.sh" if OS.linux?

    # koffi binaries moved to `@koromix/koffi-*`, which also ships a musl build
    node_modules.glob("@koromix/koffi-*/*").each do |dir|
      rm_r(dir) if dir.directory? && dir.basename.to_s != "#{os}_#{arch}"
    end

    # Unusable prebuilt: patching it for X11 rpaths or thinning the fat Mach-O breaks its pinned digest
    node_modules.glob("@trycua/cua-driver-*").each { |dir| rm_r(dir) }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end