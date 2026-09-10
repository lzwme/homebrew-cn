class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.9.3.tgz"
  sha256 "d1c63366833f8ae4a6ab4f3b60b1aa84ca82d03dba13d3d3eba989aa159e2449"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "999afcd664f73f2d04286b48a2349ee8bbc585be2f88614354417d90fa3ecfd0"
    sha256                               arm64_sequoia: "999afcd664f73f2d04286b48a2349ee8bbc585be2f88614354417d90fa3ecfd0"
    sha256                               arm64_sonoma:  "999afcd664f73f2d04286b48a2349ee8bbc585be2f88614354417d90fa3ecfd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efb7abd4c07134a0fa5d1b46551c2ceb41b93eae5e888537f5641e3c25916554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e414a442a03db1353973c6d11527a37f3412cca3cd112f1c9aebb86ba3691b2"
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