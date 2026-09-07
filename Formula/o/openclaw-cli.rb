class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.9.2.tgz"
  sha256 "3431f4cd2d8dbd6b936def2694ac27e19fa0256295cf4ada0f652ecf1c9ee520"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f46f0e73e2c53854bf3717ed7072554fc219ad9302154fac72584f0d05d7ca88"
    sha256                               arm64_sequoia: "f46f0e73e2c53854bf3717ed7072554fc219ad9302154fac72584f0d05d7ca88"
    sha256                               arm64_sonoma:  "f46f0e73e2c53854bf3717ed7072554fc219ad9302154fac72584f0d05d7ca88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68657dcf858a90ad26d603ab35404c08648e7a2ef698a845fd2146b999652c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494142ffee6b23e8f95e91d6b257ff8385b0d971ecd17e336a0fad8c7a3f8162"
  end

  depends_on "node"

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